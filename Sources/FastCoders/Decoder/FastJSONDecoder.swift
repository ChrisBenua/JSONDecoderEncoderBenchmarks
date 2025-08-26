// swiftlint:disable all

import Foundation

/// A marker protocol used to determine whether a value is a `String`-keyed `Dictionary`
/// containing `Decodable` values (in which case it should be exempt from key conversion strategies).
///
/// The marker protocol also provides access to the type of the `Decodable` values,
/// which is needed for the implementation of the key conversion strategy exemption.
protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}

extension Dictionary: _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
    static var elementType: Decodable.Type { return Value.self }
}

open class FastJSONDecoder: JSONDecoder {

    private var scannerOptions: JSONScanner.Options {
        .init(assumesTopLevelDictionary: assumesTopLevelDictionary)
    }

    private var json5ScannerOptions: JSON5Scanner.Options {
        .init(assumesTopLevelDictionary: assumesTopLevelDictionary)
    }

    private var options: _Options {
        _Options(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy,
            userInfo: userInfo,
            json5: allowsJSON5
        )
    }

    fileprivate struct _Options {
        var dateDecodingStrategy: DateDecodingStrategy = .deferredToDate
        var dataDecodingStrategy: DataDecodingStrategy = .base64
        var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw
        var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys
        #if compiler(>=6.1.0)
            var userInfo: [CodingUserInfoKey: any Sendable] = [:]
        #else
            var userInfo: [CodingUserInfoKey: Any] = [:]
        #endif
        var json5: Bool = false
    }

    open override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try _decode({
            try $0.unwrap($1, as: type, for: .root, _CodingKey?.none)
        }, from: data)
    }

    private func _decode<T>(_ unwrap: (JSONDecoderImpl, JSONMap.Value) throws -> T, from data: Data) throws -> T {
        do {
            return try Self.withUTF8Representation(of: data) { utf8Buffer -> T in

                var impl: JSONDecoderImpl
                let topValue: JSONMap.Value
                do {
                    // JSON5 is implemented with a separate scanner to allow regular JSON scanning to achieve higher performance without compromising for `allowsJSON5` checks throughout.
                    // Since the resulting JSONMap is identical, the decoder implementation is mostly shared between the two, with only a few branches to handle different methods of parsing strings and numbers. Strings and numbers are not completely parsed until decoding time.
                    let map: JSONMap
                    if allowsJSON5 {
                        var scanner = JSON5Scanner(bytes: utf8Buffer, options: self.json5ScannerOptions)
                        map = try scanner.scan()
                    } else {
                        var scanner = JSONScanner(bytes: utf8Buffer, options: self.scannerOptions)
                        map = try scanner.scan()
                    }
                    topValue = map.loadValue(at: 0)!
                    impl = JSONDecoderImpl(userInfo: self.userInfo, from: map, codingPathNode: .root, options: self.options)
                }
                impl.push(value: topValue) // This is something the old implementation did and apps started relying on. Weird.
                let result = try unwrap(impl, topValue)
                let uniquelyReferenced = isKnownUniquelyReferenced(&impl)
                impl.takeOwnershipOfBackingDataIfNeeded(selfIsUniquelyReferenced: uniquelyReferenced)
                return result
            }
        } catch let error as JSONError {
            let underlyingError: Error? = error.nsError
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: mobs("The given data was not valid JSON."), underlyingError: underlyingError))
        } catch {
            throw error
        }
    }

    // Input: Data of any encoding specified by RFC4627 section 3, with or without BOM.
    // Output: The closure is invoked with a UInt8 buffer containing the valid UTF-8 representation. If the input contained a BOM, that BOM will be excluded in the resulting buffer.
    // If the input cannot be fully decoded by the detected encoding or cannot be converted to UTF-8, the function will throw a JSONError.cannotConvertEntireInputDataToUTF8 error.
    // If the input is detected to already be UTF-8, the Data's buffer will be passed through without copying.
    static func withUTF8Representation<T>(of jsonData: Data, _ closure: (BufferView<UInt8>) throws -> T) throws -> T {
        return try jsonData.withBufferView {
            [length = jsonData.count] bytes in
            assert(bytes.count == length)
            // RFC4627 section 3
            // The first two characters of a JSON text will always be ASCII. We can determine encoding by looking at the first four bytes.
            let byte0 = (length > 0) ? bytes[uncheckedOffset: 0] : nil
            let byte1 = (length > 1) ? bytes[uncheckedOffset: 1] : nil
            let byte2 = (length > 2) ? bytes[uncheckedOffset: 2] : nil
            let byte3 = (length > 3) ? bytes[uncheckedOffset: 3] : nil

            // Check for explicit BOM first, then check the first two bytes. Note that if there is a BOM, we have to create our string without it.
            // This isn't strictly part of the JSON spec but it's useful to do anyway.
            let sourceEncoding: String.Encoding
            let bomLength: Int
            switch (byte0, byte1, byte2, byte3) {
            case (0, 0, 0xFE, 0xFF):
                sourceEncoding = .utf32BigEndian
                bomLength = 4
            case (0xFE, 0xFF, 0, 0):
                sourceEncoding = .utf32LittleEndian
                bomLength = 4
            case (0xFE, 0xFF, _, _):
                sourceEncoding = .utf16BigEndian
                bomLength = 2
            case (0xFF, 0xFE, _, _):
                sourceEncoding = .utf16LittleEndian
                bomLength = 2
            case (0xEF, 0xBB, 0xBF, _):
                sourceEncoding = .utf8
                bomLength = 3
            case let (0, 0, 0, .some(nz)) where nz != 0:
                sourceEncoding = .utf32BigEndian
                bomLength = 0
            case let (0, .some(nz1), 0, .some(nz2)) where nz1 != 0 && nz2 != 0:
                sourceEncoding = .utf16BigEndian
                bomLength = 0
            case let (.some(nz), 0, 0, 0) where nz != 0:
                sourceEncoding = .utf32LittleEndian
                bomLength = 0
            case let (.some(nz1), 0, .some(nz2), 0) where nz1 != 0 && nz2 != 0:
                sourceEncoding = .utf16LittleEndian
                bomLength = 0

            // These cases technically aren't specified by RFC4627, since it only covers cases where the input has at least 4 octets. However, when parsing JSON with fragments allowed, it's possible to have a valid UTF-16 input that is a single digit, which is 2 octets. To properly support these inputs, we'll extend the pattern described above for 4 octets of UTF-16.
            case let (0, .some(nz), nil, nil) where nz != 0:
                sourceEncoding = .utf16BigEndian
                bomLength = 0
            case let (.some(nz), 0, nil, nil) where nz != 0:
                sourceEncoding = .utf16LittleEndian
                bomLength = 0

            default:
                sourceEncoding = .utf8
                bomLength = 0
            }
            let postBOMBuffer = bytes.dropFirst(bomLength)
            if sourceEncoding == .utf8 {
                return try closure(postBOMBuffer)
            } else {
                guard var string = String(bytes: postBOMBuffer, encoding: sourceEncoding) else {
                    throw JSONError.cannotConvertEntireInputDataToUTF8
                }
                return try string.withUTF8 {
                    // String never passes an empty buffer with a `nil` `baseAddress`.
                    try closure(BufferView(unsafeBufferPointer: $0)!)
                }
            }
        }
    }
}

// in one file to access fileprivate properties
fileprivate class JSONDecoderImpl {
    var values: [JSONMap.Value] = []
    let userInfo: [CodingUserInfoKey: Any]
    var jsonMap: JSONMap
    let options: FastJSONDecoder._Options

    var codingPathNode: _CodingPathNode
    public var codingPath: [CodingKey] {
        codingPathNode.path
    }

    var topValue: JSONMap.Value { values.last! }
    func push(value: __owned JSONMap.Value) {
        values.append(value)
    }

    func popValue() {
        values.removeLast()
    }

    init(userInfo: [CodingUserInfoKey: Any], from map: JSONMap, codingPathNode: _CodingPathNode, options: FastJSONDecoder._Options) {
        self.userInfo = userInfo
        self.codingPathNode = codingPathNode
        self.jsonMap = map
        self.options = options
    }

    @inline(__always)
    func withBuffer<T>(for region: JSONMap.Region, perform closure: @Sendable(_ jsonBytes: BufferView<UInt8>, _ fullSource: BufferView<UInt8>) throws -> T) rethrows -> T {
        try jsonMap.withBuffer(for: region, perform: closure)
    }

    // This JSONDecoderImpl may have multiple references if an init(from: Decoder) implementation allows the Decoder (this object) to escape, or if a container escapes.
    // The JSONMap might have multiple references if a superDecoder, which creates a different JSONDecoderImpl instance but references the same JSONMap, is allowed to escape.
    // In either case, we need to copy-in the input buffer since it's about to go out of scope.
    func takeOwnershipOfBackingDataIfNeeded(selfIsUniquelyReferenced: Bool) {
        if !selfIsUniquelyReferenced || !isKnownUniquelyReferenced(&jsonMap) {
            jsonMap.copyInBuffer()
        }
    }
}

extension JSONDecoderImpl: Decoder {
    func container<Key: CodingKey>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> {
        switch topValue {
        case let .object(region):
            let container = try KeyedContainer<Key>(
                impl: self,
                codingPathNode: codingPathNode,
                region: region
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: Any].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: mobs("Cannot get keyed decoding container -- found null value instead")
            ))
        default:
            throw DecodingError.typeMismatch([String: Any].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: mobs("Expected to decode \([String: Any].self) but found \(topValue.debugDataTypeDescription) instead.")
            ))
        }
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch topValue {
        case let .array(region):
            return UnkeyedContainer(
                impl: self,
                codingPathNode: codingPathNode,
                region: region
            )
        case .null:
            throw DecodingError.valueNotFound([Any].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: mobs("Cannot get unkeyed decoding container -- found null value instead")
            ))
        default:
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: mobs("Expected to decode \([Any].self) but found \(topValue.debugDataTypeDescription) instead.")
            ))
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }

    // MARK: Special case handling

    @inline(__always)
    func checkNotNull<T>(_ value: JSONMap.Value, expectedType: T.Type, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws {
        if case .null = value {
            throw DecodingError.valueNotFound(expectedType, DecodingError.Context(
                codingPath: codingPathNode.path(byAppending: additionalKey),
                debugDescription: mobs("Cannot get value of type \(expectedType) -- found null value instead")
            ))
        }
    }

    // Instead of creating a new JSONDecoderImpl for passing to methods that take Decoder arguments, wrap the access in this method, which temporarily mutates this JSONDecoderImpl instance with the nested value and its coding path.
    @inline(__always)
    func with<T>(value: JSONMap.Value, path: _CodingPathNode?, perform closure: () throws -> T) rethrows -> T {
        let oldPath = codingPathNode
        if let path {
            codingPathNode = path
        }
        push(value: value)

        defer {
            if path != nil {
                self.codingPathNode = oldPath
            }
            self.popValue()
        }

        return try closure()
    }

    func unwrap<T: Decodable>(_ mapValue: JSONMap.Value, as type: T.Type, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> T {
        if type == Date.self {
            return try unwrapDate(from: mapValue, for: codingPathNode, additionalKey) as! T
        }
        if type == Data.self {
            return try unwrapData(from: mapValue, for: codingPathNode, additionalKey) as! T
        }
        if type == URL.self {
            return try unwrapURL(from: mapValue, for: codingPathNode, additionalKey) as! T
        }
        if type == Decimal.self {
            return try unwrapDecimal(from: mapValue, for: codingPathNode, additionalKey) as! T
        }
        switch options.keyDecodingStrategy {
        case .useDefaultKeys:
            break
        case .convertFromSnakeCase, .custom:
            if T.self is _JSONStringDictionaryDecodableMarker.Type {
                return try unwrapDictionary(from: mapValue, as: type, for: codingPathNode, additionalKey)
            }
        @unknown default:
            if T.self is _JSONStringDictionaryDecodableMarker.Type {
                return try unwrapDictionary(from: mapValue, as: type, for: codingPathNode, additionalKey)
            }
        }

        return try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
            try type.init(from: self)
        }
    }

    private func unwrapDictionary<T: Decodable>(from mapValue: JSONMap.Value, as type: T.Type, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> T {
        try checkNotNull(mapValue, expectedType: [String: Any].self, for: codingPathNode, additionalKey)

        guard let dictType = type as? (_JSONStringDictionaryDecodableMarker & Decodable).Type else {
            preconditionFailure("Must only be called if T implements __JSONStringDictionaryDecodableMarker")
        }

        guard case let .object(region) = mapValue else {
            throw DecodingError.typeMismatch([String: Any].self, DecodingError.Context(
                codingPath: codingPathNode.path(byAppending: additionalKey),
                debugDescription: "Expected to decode \([String: Any].self) but found \(mapValue.debugDataTypeDescription) instead."
            ))
        }

        var result = [String: Any]()
        result.reserveCapacity(region.count / 2)

        let dictCodingPathNode = codingPathNode.appending(additionalKey)

        var iter = jsonMap.makeObjectIterator(from: region.startOffset)
        while let (keyValue, value) = iter.next() {
            // We know these values are keys, but UTF-8 decoding could still fail.
            let key = try unwrapString(from: keyValue, for: dictCodingPathNode, _CodingKey?.none)
            let value = try unwrap(value, as: dictType.elementType, for: dictCodingPathNode, _CodingKey(stringValue: key)!)
            result[key]._setIfNil(to: value)
        }

        return result as! T
    }

    @available(macOS 12, *)
    func unwrap<T: DecodableWithConfiguration>(_ mapValue: JSONMap.Value, as type: T.Type, configuration: T.DecodingConfiguration, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> T {
        try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
            try type.init(from: self, configuration: configuration)
        }
    }

    private func unwrapDate<K: CodingKey>(from mapValue: JSONMap.Value, for codingPathNode: _CodingPathNode, _ additionalKey: K? = nil) throws -> Date {
        try checkNotNull(mapValue, expectedType: Date.self, for: codingPathNode, additionalKey)

        switch options.dateDecodingStrategy {
        case .deferredToDate:
            return try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
                try Date(from: self)
            }

        case .secondsSince1970:
            let double = try unwrapFloatingPoint(from: mapValue, as: Double.self, for: codingPathNode, additionalKey)
            return Date(timeIntervalSince1970: double)

        case .millisecondsSince1970:
            let double = try unwrapFloatingPoint(from: mapValue, as: Double.self, for: codingPathNode, additionalKey)
            return Date(timeIntervalSince1970: double / 1000.0)
        case .iso8601:
            let string = try unwrapString(from: mapValue, for: codingPathNode, additionalKey)
            guard let date = try? Date.ISO8601FormatStyle().parse(string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: mobs("Expected date string to be ISO8601-formatted.")))
            }
            return date

        case let .formatted(formatter):
            let string = try unwrapString(from: mapValue, for: codingPathNode, additionalKey)
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPathNode.path(byAppending: additionalKey), debugDescription: mobs("Date string does not match format expected by formatter.")))
            }
            return date
        case let .custom(closure):
            return try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
                try closure(self)
            }
        @unknown default:
            fatalError()
        }
    }

    private func unwrapData(from mapValue: JSONMap.Value, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> Data {
        try checkNotNull(mapValue, expectedType: Data.self, for: codingPathNode, additionalKey)

        switch options.dataDecodingStrategy {
        case .deferredToData:
            return try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
                try Data(from: self)
            }

        case .base64:
            guard case let .string(region, isSimple) = mapValue else {
                throw createTypeMismatchError(type: String.self, for: codingPathNode.path(byAppending: additionalKey), value: mapValue)
            }
            var data: Data?
            if isSimple {
                data = withBuffer(for: region) { buffer, _ in
                    Data(decodingBase64: buffer)
                }
            }
            if data == nil {
                // For compatibility, try decoding as a string and then base64 decoding it.
                let string = try unwrapString(from: mapValue, for: codingPathNode, additionalKey)
                data = Data(base64Encoded: string)
            }
            guard let data else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPathNode.path(byAppending: additionalKey), debugDescription: mobs("Encountered Data is not valid Base64.")))
            }

            return data

        case let .custom(closure):
            return try with(value: mapValue, path: codingPathNode.appending(additionalKey)) {
                try closure(self)
            }
        @unknown default:
            fatalError()
        }
    }

    private func unwrapURL(from mapValue: JSONMap.Value, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> URL {
        try checkNotNull(mapValue, expectedType: URL.self, for: codingPathNode, additionalKey)

        let string = try unwrapString(from: mapValue, for: codingPathNode, additionalKey)
        guard let url = URL(string: string) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: codingPathNode.path(byAppending: additionalKey),
                debugDescription: mobs("Invalid URL string.")
            ))
        }
        return url
    }

    private func unwrapDecimal(from mapValue: JSONMap.Value, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> Decimal {
        try checkNotNull(mapValue, expectedType: Decimal.self, for: codingPathNode, additionalKey)

        guard case let .number(region, hasExponent) = mapValue else {
            throw DecodingError.typeMismatch(Decimal.self, DecodingError.Context(codingPath: codingPathNode.path(byAppending: additionalKey), debugDescription: ""))
        }

        let json5 = options.json5
        return try withBuffer(for: region) { numberBuffer, fullSource in
            if json5 {
                let (digitsStartPtr, isHex, isSpecialJSON5DoubleValue) = try JSON5Scanner.prevalidateJSONNumber(from: numberBuffer, fullSource: fullSource)

                // Use our integer parsers for hex data, because the underlying strtod() implementation of T(prevalidatedBuffer:) is too permissive (e.g. it accepts decimals and 'p' exponents) which otherwise would require prevalidation of the entire string before calling it.
                if isHex {
                    if numberBuffer.first! == UInt8(ascii: "-") {
                        guard let int = Int64(prevalidatedJSON5Buffer: numberBuffer, isHex: isHex), let decimal = Decimal(exactly: int) else {
                            throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                        }
                        return decimal
                    } else {
                        guard let int = UInt64(prevalidatedJSON5Buffer: numberBuffer, isHex: isHex), let decimal = Decimal(exactly: int) else {
                            throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                        }
                        return decimal
                    }
                } else if isSpecialJSON5DoubleValue {
                    // Decimal itself doesn't have support for Infinity values yet. Even the part of the old NSJSONSerialization implementation that would try to reinterpret an NaN or Infinity value as an NSDecimalNumber did not have very predictable behavior.
                    // TODO: Proper handling of Infinity and NaN Decimal values.
                    return Decimal.quietNaN
                } else {
                    switch CustomDecimal._decimal(from: numberBuffer, matchEntireString: true) {
                    case let .success(result, _):
                        return Decimal(_exponent: result._exponent, _length: result._length, _isNegative: result._isNegative, _isCompact: result._isCompact, _reserved: result._reserved, _mantissa: result._mantissa)
                    case .overlargeValue:
                        throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                    case .parseFailure:
                        throw JSON5Scanner.validateNumber(from: numberBuffer.suffix(from: digitsStartPtr), fullSource: fullSource)
                    }
                }

            } else {
                let digitsStartPtr = try JSONScanner.prevalidateJSONNumber(from: numberBuffer, hasExponent: hasExponent, fullSource: fullSource)
                switch CustomDecimal._decimal(from: numberBuffer, matchEntireString: true) {
                case let .success(result, _):
                    return Decimal(_exponent: result._exponent, _length: result._length, _isNegative: result._isNegative, _isCompact: result._isCompact, _reserved: result._reserved, _mantissa: result._mantissa)
                case .overlargeValue:
                    throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                case .parseFailure:
                    throw JSONScanner.validateNumber(from: numberBuffer.suffix(from: digitsStartPtr), fullSource: fullSource)
                }
            }
        }
    }

    private func unwrapString(from value: JSONMap.Value, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil) throws -> String {
        try checkNotNull(value, expectedType: String.self, for: codingPathNode, additionalKey)

        guard case let .string(region, isSimple) = value else {
            throw createTypeMismatchError(type: String.self, for: codingPathNode.path(byAppending: additionalKey), value: value)
        }
        let json5 = options.json5
        return try withBuffer(for: region) { stringBuffer, fullSource in
            if isSimple {
                guard let result = String._tryFromUTF8(stringBuffer) else {
                    throw JSONError.cannotConvertInputStringDataToUTF8(location: .sourceLocation(at: stringBuffer.startIndex, fullSource: fullSource))
                }
                return result
            }
            if json5 {
                return try JSON5Scanner.stringValue(from: stringBuffer, fullSource: fullSource)
            } else {
                return try JSONScanner.stringValue(from: stringBuffer, fullSource: fullSource)
            }
        }
    }

    static func isTrueZero(_ buffer: BufferView<UInt8>) -> Bool {
        var remainingBuffer = buffer

        // Non-zero numbers are allowed after 'e'/'E'. Since the format is already validated at this stage, we can stop scanning as soon as we see one.
        let nonZeroRange = UInt8(ascii: "1") ... UInt8(ascii: "9")

        @inline(__always)
        func check(_ off: Int) -> Bool? {
            switch remainingBuffer[uncheckedOffset: off] {
            case nonZeroRange: return false
            case UInt8(ascii: "e"), UInt8(ascii: "E"): return true
            default: return nil
            }
        }

        // Manual loop unrolling.
        while remainingBuffer.count >= 4 {
            if let res = check(0) { return res }
            if let res = check(1) { return res }
            if let res = check(2) { return res }
            if let res = check(3) { return res }

            remainingBuffer = remainingBuffer.dropFirst(4)
        }

        // Process any remaining bytes in the same way.
        switch remainingBuffer.count {
        case 3:
            if let res = check(2) { return res }
            fallthrough
        case 2:
            if let res = check(1) { return res }
            fallthrough
        case 1:
            if let res = check(0) { return res }
        default:
            break
        }

        return true
    }

    private func unwrapFloatingPoint<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>(
        from value: JSONMap.Value,
        as type: T.Type,
        for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil
    ) throws -> T {
        try checkNotNull(value, expectedType: type, for: codingPathNode, additionalKey)

        // We are always willing to return the number as a Double:
        // * If the original value was integral, it is guaranteed to fit in a Double;
        //   we are willing to lose precision past 2^53 if you encoded a UInt64 but requested a Double
        // * If it was a Float or Double, you will get back the precise value
        // * If it was Decimal, you will get back the nearest approximation

        if case let .number(region, hasExponent) = value {
            let json5 = options.json5
            return try withBuffer(for: region) { numberBuffer, fullSource in
                if json5 {
                    let (digitsStartPtr, isHex, isSpecialJSON5DoubleValue) = try JSON5Scanner.prevalidateJSONNumber(from: numberBuffer, fullSource: fullSource)

                    // Use our integer parsers for hex data, because the underlying strtod() implementation of T(prevalidatedBuffer:) is too permissive (e.g. it accepts decimals and 'p' exponents) which otherwise would require prevalidation of the entire string before calling it.
                    if isHex {
                        if numberBuffer.first.unsafelyUnwrapped == UInt8(ascii: "-") {
                            guard let int = Int64(prevalidatedJSON5Buffer: numberBuffer, isHex: isHex), let float = T(exactly: int) else {
                                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                            }
                            return float
                        } else {
                            guard let int = UInt64(prevalidatedJSON5Buffer: numberBuffer, isHex: isHex), let float = T(exactly: int) else {
                                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                            }
                            return float
                        }
                    } // else, fall through to the T(prevalidatedBuffer:) invocation, which is otherwise compatible with JSON5 after our pre-validation.

                    if let floatingPoint = T(prevalidatedBuffer: numberBuffer) {
                        // Check for overflow/underflow, which can result in "rounding" to infinity or zero.
                        // While strtod does set ERANGE in the either case, we don't rely on it because setting errno to 0 first and then check the result is surprisingly expensive. For values "rounded" to infinity, we reject those out of hand, unless it's an explicit JSON5 infinity/nan value. For values "rounded" down to zero, we perform check for any non-zero digits in the input, which turns out to be much faster.
                        if floatingPoint.isFinite {
                            guard floatingPoint != 0 || Self.isTrueZero(numberBuffer) else {
                                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                            }
                            return floatingPoint
                        } else {
                            if json5, isSpecialJSON5DoubleValue {
                                return floatingPoint
                            } else {
                                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                            }
                        }
                    }

                    // We failed to parse the number. Is that because it was malformed?
                    throw JSON5Scanner.validateNumber(from: numberBuffer.suffix(from: digitsStartPtr), fullSource: fullSource)
                } else {
                    let digitsStartPtr = try JSONScanner.prevalidateJSONNumber(from: numberBuffer, hasExponent: hasExponent, fullSource: fullSource)

                    if let floatingPoint = T(prevalidatedBuffer: numberBuffer) {
                        // Check for overflow (which results in an infinite result), or rounding to zero.
                        // While strtod does set ERANGE in the either case, we don't rely on it because setting errno to 0 first and then check the result is surprisingly expensive. For values "rounded" to infinity, we reject those out of hand. For values "rounded" down to zero, we perform check for any non-zero digits in the input, which turns out to be much faster.
                        if floatingPoint.isFinite {
                            guard floatingPoint != 0 || Self.isTrueZero(numberBuffer) else {
                                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                            }
                            return floatingPoint
                        } else {
                            throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                        }
                    }

                    throw JSONScanner.validateNumber(from: numberBuffer.suffix(from: digitsStartPtr), fullSource: fullSource)
                }
            }
        }

        if case let .string(region, isSimple) = value, isSimple,
            case let .convertFromString(posInfString, negInfString, nanString) =
            options.nonConformingFloatDecodingStrategy {
            let result = withBuffer(for: region) { (stringBuffer, _) -> T? in
                var posInfString = posInfString
                var negInfString = negInfString
                var nanString = nanString
                return stringBuffer.withUnsafeRawPointer { (ptr, count) -> T? in
                    func bytesAreEqual(_ b: UnsafeBufferPointer<UInt8>) -> Bool {
                        count == b.count && memcmp(ptr, b.baseAddress!, b.count) == 0
                    }
                    if posInfString.withUTF8(bytesAreEqual(_:)) { return T.infinity }
                    if negInfString.withUTF8(bytesAreEqual(_:)) { return -T.infinity }
                    if nanString.withUTF8(bytesAreEqual(_:)) { return T.nan }
                    return nil
                }
            }
            if let result { return result }
        }

        throw createTypeMismatchError(type: type, for: codingPathNode.path(byAppending: additionalKey), value: value)
    }

    private func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: JSONMap.Value,
        as type: T.Type,
        for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)? = nil
    ) throws -> T {
        try checkNotNull(value, expectedType: type, for: codingPathNode, additionalKey)

        guard case let .number(region, hasExponent) = value else {
            throw createTypeMismatchError(type: type, for: codingPathNode.path(byAppending: additionalKey), value: value)
        }
        let json5 = options.json5
        return try withBuffer(for: region) { numberBuffer, fullSource in
            let digitBeginning: BufferViewIndex<UInt8>
            if json5 {
                let isHex: Bool
                let isSpecialFloatValue: Bool
                (digitBeginning, isHex, isSpecialFloatValue) = try JSON5Scanner.prevalidateJSONNumber(from: numberBuffer, fullSource: fullSource)

                // This is the fast pass. Number directly convertible to desired integer type.
                if let integer = T(prevalidatedJSON5Buffer: numberBuffer, isHex: isHex) {
                    return integer
                }

                // NaN and Infinity values are not representable as Integers.
                if isSpecialFloatValue {
                    throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
                }
            } else {
                digitBeginning = try JSONScanner.prevalidateJSONNumber(from: numberBuffer, hasExponent: hasExponent, fullSource: fullSource)

                // This is the fast pass. Number directly convertible to Integer.
                if let integer = T(prevalidatedBuffer: numberBuffer) {
                    return integer
                }
            }

            return try Self._slowpath_unwrapFixedWidthInteger(as: type, json5: json5, numberBuffer: numberBuffer, fullSource: fullSource, digitBeginning: digitBeginning, for: codingPathNode, additionalKey)
        }
    }

    private static func _slowpath_unwrapFixedWidthInteger<T: FixedWidthInteger>(as type: T.Type, json5: Bool, numberBuffer: BufferView<UInt8>, fullSource: BufferView<UInt8>, digitBeginning: BufferViewIndex<UInt8>, for codingPathNode: _CodingPathNode, _ additionalKey: (some CodingKey)?) throws -> T {
        // This is the slow path... If the fast path has failed. For example for "34.0" as an integer, we try to parse as either a Decimal or a Double and then convert back, losslessly.
        if let double = Double(prevalidatedBuffer: numberBuffer) {
            // T.init(exactly:) guards against non-integer Double(s), but the parser may
            // have already transformed the non-integer "1.0000000000000001" into 1, etc.
            // Proper lossless behavior should be implemented by the parser.
            guard let value = T(exactly: double) else {
                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
            }

            // The distance between Double(s) is >=2 from ±2^53.
            // 2^53 may represent either 2^53 or 2^53+1 rounded toward zero.
            // This code makes it so you don't get integer A from integer B.
            // Proper lossless behavior should be implemented by the parser.
            if double.magnitude < Double(sign: .plus, exponent: Double.significandBitCount + 1, significand: 1) {
                return value
            }
        }

        let decimalParseResult = CustomDecimal._decimal(from: numberBuffer, matchEntireString: true).asOptional
        if let result = decimalParseResult.result {
            guard let value = T(result) else {
                throw JSONError.numberIsNotRepresentableInSwift(parsed: String(decoding: numberBuffer, as: UTF8.self))
            }
            return value
        }
        // Maybe it was just an unreadable sequence?
        if json5 {
            throw JSON5Scanner.validateNumber(from: numberBuffer.suffix(from: digitBeginning), fullSource: fullSource)
        } else {
            throw JSONScanner.validateNumber(from: numberBuffer.suffix(from: digitBeginning), fullSource: fullSource)
        }
    }

    private func createTypeMismatchError(type: Any.Type, for path: [CodingKey], value: JSONMap.Value) -> DecodingError {
        return DecodingError.typeMismatch(type, .init(
            codingPath: path,
            debugDescription: mobs("Expected to decode \(type) but found \(value.debugDataTypeDescription) instead.")
        ))
    }
}

extension FixedWidthInteger {
    init?(_ decimal: CustomDecimal) {
        let isNegative = decimal._isNegative != 0
        if decimal._length == 0, isNegative {
            return nil
        }
        if isNegative {
            guard Self.isSigned else {
                return nil
            }
        }

        var d: UInt64 = 0
        for i in (0 ..< decimal._length).reversed() {
            let overflow1: Bool
            let overflow2: Bool
            (d, overflow1) = d.multipliedReportingOverflow(by: 65536)
            (d, overflow2) = d.addingReportingOverflow(UInt64(decimal[i]))
            guard !overflow1, !overflow2 else {
                return nil
            }
        }
        if decimal._exponent < 0 {
            for _ in 0 ..< -decimal._exponent {
                let overflow: Bool
                (d, overflow) = d.dividedReportingOverflow(by: 10)
                guard !overflow else {
                    return nil
                }
            }
        } else {
            for _ in 0 ..< decimal._exponent {
                let overflow: Bool
                (d, overflow) = d.multipliedReportingOverflow(by: 10)
                guard !overflow else {
                    return nil
                }
            }
        }
        if isNegative {
            guard let signedAndSized = Self(exactly: d) else {
                return nil
            }
            self = signedAndSized * -1
        } else {
            guard let sized = Self(exactly: d) else {
                return nil
            }
            self = sized
        }
    }
}

extension JSONDecoderImpl: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        switch topValue {
        case .null:
            return true
        default:
            return false
        }
    }

    func decode(_: Bool.Type) throws -> Bool {
        guard case let .bool(bool) = topValue else {
            throw createTypeMismatchError(type: Bool.self, for: codingPath, value: topValue)
        }

        return bool
    }

    func decode(_: String.Type) throws -> String {
        try unwrapString(from: topValue, for: codingPathNode, _CodingKey?.none)
    }

    func decode(_: Double.Type) throws -> Double {
        try decodeFloatingPoint()
    }

    func decode(_: Float.Type) throws -> Float {
        try decodeFloatingPoint()
    }

    func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func decode(_: Int128.Type) throws -> Int128 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func decode(_: UInt128.Type) throws -> UInt128 {
        try decodeFixedWidthInteger()
    }

    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try unwrap(topValue, as: type, for: codingPathNode, _CodingKey?.none)
    }

    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        try unwrapFixedWidthInteger(from: topValue, as: T.self, for: codingPathNode, _CodingKey?.none)
    }

    @inline(__always) private func decodeFloatingPoint<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>() throws -> T {
        try unwrapFloatingPoint(from: topValue, as: T.self, for: codingPathNode, _CodingKey?.none)
    }
}

extension JSONDecoderImpl {
    struct KeyedContainer<K> {
        typealias Key = K

        let impl: JSONDecoderImpl
        let codingPathNode: _CodingPathNode
        let dictionary: [String: JSONMap.Value]
    }
}

extension JSONDecoderImpl.KeyedContainer: KeyedDecodingContainerProtocol where K: CodingKey {

    static func stringify(objectRegion: JSONMap.Region, using impl: JSONDecoderImpl, codingPathNode: _CodingPathNode, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) throws -> [String: JSONMap.Value] {
        var result = [String: JSONMap.Value]()
        result.reserveCapacity(objectRegion.count / 2)

        var iter = impl.jsonMap.makeObjectIterator(from: objectRegion.startOffset)
        switch keyDecodingStrategy {
        case .useDefaultKeys:
            while let (keyValue, value) = iter.next() {
                // We know these values are keys, but UTF-8 decoding could still fail.
                let key = try impl.unwrapString(from: keyValue, for: codingPathNode, _CodingKey?.none)
                result[key]._setIfNil(to: value)
            }
        case .convertFromSnakeCase:
            while let (keyValue, value) = iter.next() {
                // We know these values are keys, but UTF-8 decoding could still fail.
                let key = try impl.unwrapString(from: keyValue, for: codingPathNode, _CodingKey?.none)

                // Convert the snake case keys in the container to camel case.
                // If we hit a duplicate key after conversion, then we'll use the first one we saw.
                // Effectively an undefined behavior with JSON dictionaries.
                result[JSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(key)]._setIfNil(to: value)
            }
        case let .custom(converter):
            let codingPathForCustomConverter = codingPathNode.path
            while let (keyValue, value) = iter.next() {
                // We know these values are keys, but UTF-8 decoding could still fail.
                let key = try impl.unwrapString(from: keyValue, for: codingPathNode, _CodingKey?.none)

                var pathForKey = codingPathForCustomConverter
                pathForKey.append(_CodingKey(stringValue: key)!)
                result[converter(pathForKey).stringValue]._setIfNil(to: value)
            }
        @unknown default:
            fatalError()
        }

        return result
    }

    init(impl: JSONDecoderImpl, codingPathNode: _CodingPathNode, region: JSONMap.Region) throws {
        self.impl = impl
        self.codingPathNode = codingPathNode
        self.dictionary = try Self.stringify(objectRegion: region, using: impl, codingPathNode: codingPathNode, keyDecodingStrategy: impl.options.keyDecodingStrategy)
    }

    var codingPath: [CodingKey] {
        codingPathNode.path
    }

    var allKeys: [K] {
        dictionary.keys.compactMap { K(stringValue: $0) }
    }

    func contains(_ key: K) -> Bool {
        dictionary.keys.contains(key.stringValue)
    }

    func decodeNil(forKey key: K) throws -> Bool {
        guard case .null = try getValue(forKey: key) else {
            return false
        }
        return true
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        let value = try getValue(forKey: key)

        guard case let .bool(bool) = value else {
            throw createTypeMismatchError(type: type, forKey: key, value: value)
        }

        return bool
    }

    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard let value = getValueIfPresent(forKey: key) else {
            return nil
        }
        switch value {
        case .null: return nil
        case let .bool(result): return result
        default: throw createTypeMismatchError(type: type, forKey: key, value: value)
        }
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        let value = try getValue(forKey: key)
        return try impl.unwrapString(from: value, for: codingPathNode, key)
    }

    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard let value = getValueIfPresent(forKey: key) else {
            return nil
        }
        switch value {
        case .null: return nil
        default: return try impl.unwrapString(from: value, for: codingPathNode, key)
        }
    }

    func decode(_: Double.Type, forKey key: K) throws -> Double {
        try decodeFloatingPoint(key: key)
    }

    func decodeIfPresent(_: Double.Type, forKey key: K) throws -> Double? {
        try decodeFloatingPointIfPresent(key: key)
    }

    func decode(_: Float.Type, forKey key: K) throws -> Float {
        try decodeFloatingPoint(key: key)
    }

    func decodeIfPresent(_: Float.Type, forKey key: K) throws -> Float? {
        try decodeFloatingPointIfPresent(key: key)
    }

    func decode(_: Int.Type, forKey key: K) throws -> Int {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: Int.Type, forKey key: K) throws -> Int? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: Int8.Type, forKey key: K) throws -> Int8? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: Int16.Type, forKey key: K) throws -> Int16? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: Int32.Type, forKey key: K) throws -> Int32? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
        try decodeFixedWidthInteger(key: key)
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func decode(_: Int128.Type, forKey key: K) throws -> Int128 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: Int64.Type, forKey key: K) throws -> Int64? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: UInt.Type, forKey key: K) throws -> UInt {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: UInt.Type, forKey key: K) throws -> UInt? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: UInt8.Type, forKey key: K) throws -> UInt8? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: UInt16.Type, forKey key: K) throws -> UInt16? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: UInt32.Type, forKey key: K) throws -> UInt32? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
        try decodeFixedWidthInteger(key: key)
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func decode(_: UInt128.Type, forKey key: K) throws -> UInt128 {
        try decodeFixedWidthInteger(key: key)
    }

    func decodeIfPresent(_: UInt64.Type, forKey key: K) throws -> UInt64? {
        try decodeFixedWidthIntegerIfPresent(key: key)
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T {
        try impl.unwrap(try getValue(forKey: key), as: type, for: codingPathNode, key)
    }

    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T? {
        guard let value = getValueIfPresent(forKey: key) else {
            return nil
        }
        switch value {
        case .null: return nil
        default: return try impl.unwrap(value, as: type, for: codingPathNode, key)
        }
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> {
        let value = try getValue(forKey: key)
        return try impl.with(value: value, path: codingPathNode.appending(key)) {
            try impl.container(keyedBy: type)
        }
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        let value = try getValue(forKey: key)
        return try impl.with(value: value, path: codingPathNode.appending(key)) {
            try impl.unkeyedContainer()
        }
    }

    func superDecoder() throws -> Decoder {
        return decoderForKeyNoThrow(_CodingKey.super)
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        return decoderForKeyNoThrow(key)
    }

    private func decoderForKeyNoThrow(_ key: some CodingKey) -> JSONDecoderImpl {
        let value: JSONMap.Value
        do {
            value = try getValue(forKey: key)
        } catch {
            // if there no value for this key then return a null value
            value = .null
        }
        let impl = JSONDecoderImpl(userInfo: self.impl.userInfo, from: self.impl.jsonMap, codingPathNode: codingPathNode.appending(key), options: self.impl.options)
        impl.push(value: value)
        return impl
    }

    @inline(__always) private func getValue(forKey key: some CodingKey) throws -> JSONMap.Value {
        guard let value = dictionary[key.stringValue] else {
            throw DecodingError.keyNotFound(key, .init(
                codingPath: codingPath,
                debugDescription: mobs("No value associated with key \(key) (\"\(key.stringValue)\").")
            ))
        }
        return value
    }

    @inline(__always) private func getValueIfPresent(forKey key: some CodingKey) -> JSONMap.Value? {
        dictionary[key.stringValue]
    }

    private func createTypeMismatchError(type: Any.Type, forKey key: K, value: JSONMap.Value) -> DecodingError {
        return DecodingError.typeMismatch(type, .init(
            codingPath: codingPathNode.path(byAppending: key), debugDescription: mobs("Expected to decode \(type) but found \(value.debugDataTypeDescription) instead.")
        ))
    }

    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) throws -> T {
        let value = try getValue(forKey: key)
        return try impl.unwrapFixedWidthInteger(from: value, as: T.self, for: codingPathNode, key)
    }

    @inline(__always) private func decodeFloatingPoint<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>(key: K) throws -> T {
        let value = try getValue(forKey: key)
        return try impl.unwrapFloatingPoint(from: value, as: T.self, for: codingPathNode, key)
    }

    @inline(__always) private func decodeFixedWidthIntegerIfPresent<T: FixedWidthInteger>(key: Self.Key) throws -> T? {
        guard let value = getValueIfPresent(forKey: key) else {
            return nil
        }
        switch value {
        case .null: return nil
        default: return try impl.unwrapFixedWidthInteger(from: value, as: T.self, for: codingPathNode, key)
        }
    }

    @inline(__always) private func decodeFloatingPointIfPresent<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>(key: K) throws -> T? {
        guard let value = getValueIfPresent(forKey: key) else {
            return nil
        }
        switch value {
        case .null: return nil
        default: return try impl.unwrapFloatingPoint(from: value, as: T.self, for: codingPathNode, key)
        }
    }
}

extension JSONDecoderImpl {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let impl: JSONDecoderImpl
        var valueIterator: JSONMap.ArrayIterator
        var peekedValue: JSONMap.Value?
        let count: Int?

        var isAtEnd: Bool { currentIndex >= (count!) }
        var currentIndex = 0

        init(impl: JSONDecoderImpl, codingPathNode: _CodingPathNode, region: JSONMap.Region) {
            self.impl = impl
            self.codingPathNode = codingPathNode
            self.valueIterator = impl.jsonMap.makeArrayIterator(from: region.startOffset)
            self.count = region.count
        }

        let codingPathNode: _CodingPathNode
        public var codingPath: [CodingKey] {
            codingPathNode.path
        }

        @inline(__always)
        var currentIndexKey: _CodingKey {
            .init(index: currentIndex)
        }

        @inline(__always)
        var currentCodingPath: [CodingKey] {
            codingPathNode.path(byAppendingIndex: currentIndex)
        }

        private mutating func advanceToNextValue() {
            currentIndex += 1
            peekedValue = nil
        }

        mutating func decodeNil() throws -> Bool {
            let value = try peekNextValue(ofType: Never.self)
            switch value {
            case .null:
                advanceToNextValue()
                return true
            default:
                // The protocol states:
                //   If the value is not null, does not increment currentIndex.
                return false
            }
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            let value = try peekNextValue(ofType: Bool.self)
            guard case let .bool(bool) = value else {
                throw impl.createTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }

            advanceToNextValue()
            return bool
        }

        mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
            let value = peekNextValueIfPresent(ofType: Bool.self)
            let result: Bool? = switch value {
            case nil, .null: nil
            case let .bool(bool): bool
            default: throw impl.createTypeMismatchError(type: type, for: currentCodingPath, value: value!)
            }
            advanceToNextValue()
            return result
        }

        mutating func decode(_ type: String.Type) throws -> String {
            let value = try peekNextValue(ofType: String.self)
            let string = try impl.unwrapString(from: value, for: codingPathNode, currentIndexKey)
            advanceToNextValue()
            return string
        }

        mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
            let value = peekNextValueIfPresent(ofType: String.self)
            let result: String? = switch value {
            case nil, .null: nil
            default: try impl.unwrapString(from: value.unsafelyUnwrapped, for: codingPathNode, currentIndexKey)
            }
            advanceToNextValue()
            return result
        }

        mutating func decode(_: Double.Type) throws -> Double {
            try decodeFloatingPoint()
        }

        mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
            try decodeFloatingPointIfPresent()
        }

        mutating func decode(_: Float.Type) throws -> Float {
            try decodeFloatingPoint()
        }

        mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
            try decodeFloatingPointIfPresent()
        }

        mutating func decode(_: Int.Type) throws -> Int {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: Int.Type) throws -> Int? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: Int8.Type) throws -> Int8 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: Int8.Type) throws -> Int8? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: Int16.Type) throws -> Int16 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: Int16.Type) throws -> Int16? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: Int32.Type) throws -> Int32 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: Int32.Type) throws -> Int32? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: Int64.Type) throws -> Int64 {
            try decodeFixedWidthInteger()
        }

        @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
        mutating func decode(_: Int128.Type) throws -> Int128 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: Int64.Type) throws -> Int64? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: UInt.Type) throws -> UInt {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: UInt.Type) throws -> UInt? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: UInt8.Type) throws -> UInt8 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: UInt8.Type) throws -> UInt8? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: UInt16.Type) throws -> UInt16 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: UInt16.Type) throws -> UInt16? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: UInt32.Type) throws -> UInt32 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: UInt32.Type) throws -> UInt32? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode(_: UInt64.Type) throws -> UInt64 {
            try decodeFixedWidthInteger()
        }

        @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
        mutating func decode(_: UInt128.Type) throws -> UInt128 {
            try decodeFixedWidthInteger()
        }

        mutating func decodeIfPresent(_: UInt64.Type) throws -> UInt64? {
            try decodeFixedWidthIntegerIfPresent()
        }

        mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
            let value = try peekNextValue(ofType: type)
            let result = try impl.unwrap(value, as: type, for: codingPathNode, currentIndexKey)

            advanceToNextValue()
            return result
        }

        mutating func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T? {
            let value = peekNextValueIfPresent(ofType: type)
            let result: T? = switch value {
            case nil, .null: nil
            default: try impl.unwrap(value.unsafelyUnwrapped, as: type, for: codingPathNode, currentIndexKey)
            }
            advanceToNextValue()
            return result
        }

        mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
            let value = try peekNextValue(ofType: KeyedDecodingContainer<NestedKey>.self)
            let container = try impl.with(value: value, path: codingPathNode.appending(index: currentIndex)) {
                try impl.container(keyedBy: type)
            }

            advanceToNextValue()
            return container
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let value = try peekNextValue(ofType: UnkeyedDecodingContainer.self)
            let container = try impl.with(value: value, path: codingPathNode.appending(index: currentIndex)) {
                try impl.unkeyedContainer()
            }

            advanceToNextValue()
            return container
        }

        mutating func superDecoder() throws -> Decoder {
            let decoder = try decoderForNextElement(ofType: Decoder.self)
            advanceToNextValue()
            return decoder
        }

        private mutating func decoderForNextElement<T>(ofType type: T.Type) throws -> JSONDecoderImpl {
            let value = try peekNextValue(ofType: type)
            let impl = JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: self.impl.jsonMap,
                codingPathNode: codingPathNode.appending(index: currentIndex),
                options: self.impl.options
            )
            impl.push(value: value)
            return impl
        }

        @inline(__always)
        private mutating func peekNextValueIfPresent<T>(ofType type: T.Type) -> JSONMap.Value? {
            if let value = peekedValue {
                return value
            }
            guard let nextValue = valueIterator.next() else {
                return nil
            }
            peekedValue = nextValue
            return nextValue
        }

        @inline(__always)
        private mutating func peekNextValue<T>(ofType type: T.Type) throws -> JSONMap.Value {
            guard let nextValue = peekNextValueIfPresent(ofType: type) else {
                var message = mobs("Unkeyed container is at end.")
                if T.self == UnkeyedContainer.self {
                    message = mobs("Cannot get nested unkeyed container -- unkeyed container is at end.")
                }
                if T.self == Decoder.self {
                    message = mobs("Cannot get superDecoder() -- unkeyed container is at end.")
                }

                var path = codingPath
                path.append(_CodingKey(index: currentIndex))

                throw DecodingError.valueNotFound(
                    type,
                    .init(
                        codingPath: path,
                        debugDescription: message,
                        underlyingError: nil
                    )
                )
            }
            return nextValue
        }

        @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
            let value = try peekNextValue(ofType: T.self)
            let key = _CodingKey(index: currentIndex)
            let result = try impl.unwrapFixedWidthInteger(from: value, as: T.self, for: codingPathNode, key)
            advanceToNextValue()
            return result
        }

        @inline(__always) private mutating func decodeFloatingPoint<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>() throws -> T {
            let value = try peekNextValue(ofType: T.self)
            let key = _CodingKey(index: currentIndex)
            let result = try impl.unwrapFloatingPoint(from: value, as: T.self, for: codingPathNode, key)
            advanceToNextValue()
            return result
        }

        @inline(__always) private mutating func decodeFixedWidthIntegerIfPresent<T: FixedWidthInteger>() throws -> T? {
            let value = peekNextValueIfPresent(ofType: T.self)
            let result: T? = switch value {
            case nil, .null: nil
            default: try impl.unwrapFixedWidthInteger(from: value.unsafelyUnwrapped, as: T.self, for: codingPathNode, currentIndexKey)
            }
            advanceToNextValue()
            return result
        }

        @inline(__always) private mutating func decodeFloatingPointIfPresent<T: PrevalidatedJSONNumberBufferConvertible & BinaryFloatingPoint>() throws -> T? {
            let value = peekNextValueIfPresent(ofType: T.self)
            let result: T? = switch value {
            case nil, .null: nil
            default: try impl.unwrapFloatingPoint(from: value.unsafelyUnwrapped, as: T.self, for: codingPathNode, currentIndexKey)
            }
            advanceToNextValue()
            return result
        }
    }
}

extension Optional {
    fileprivate mutating func _setIfNil(to value: Wrapped) {
        guard _fastPath(self == nil) else { return }
        self = value
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    fileprivate static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }

        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore, stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }

        let keyRange = firstNonUnderscore ... lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex ..< firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore) ..< stringKey.endIndex

        let components = stringKey[keyRange].split(separator: "_")
        let joinedString: String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }

        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result: String
        if leadingUnderscoreRange.isEmpty, trailingUnderscoreRange.isEmpty {
            result = joinedString
        } else if !leadingUnderscoreRange.isEmpty, !trailingUnderscoreRange.isEmpty {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if !leadingUnderscoreRange.isEmpty {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
}
// swiftlint:enable all
