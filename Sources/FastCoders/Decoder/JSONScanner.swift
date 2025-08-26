import Foundation


// swiftlint:disable all
internal struct JSONScanner {
    let options: Options
    var reader: DocumentReader
    var depth: Int = 0
    var partialMap = JSONPartialMapData()

    internal struct Options {
        var assumesTopLevelDictionary = false
    }

    struct JSONPartialMapData {
        var mapData: [Int] = []
        var prevMapDataSize = 0

        mutating func resizeIfNecessary(with reader: DocumentReader) {
            let currentCount = mapData.count
            if currentCount > 0, currentCount.isMultiple(of: 2048) {
                // Time to predict how big these arrays are going to be based on the current rate of consumption per processed bytes.
                // total objects = (total bytes / current bytes) * current objects
                let totalBytes = reader.bytes.count
                let consumedBytes = reader.byteOffset(at: reader.readIndex)
                let ratio = (Double(totalBytes) / Double(consumedBytes))
                let totalExpectedMapSize = Int(Double(mapData.count) * ratio)
                if prevMapDataSize == 0 || Double(totalExpectedMapSize) / Double(prevMapDataSize) > 1.25 {
                    mapData.reserveCapacity(totalExpectedMapSize)
                    prevMapDataSize = totalExpectedMapSize
                }
            }
        }

        mutating func recordStartCollection(tagType: JSONMap.TypeDescriptor, with reader: DocumentReader) -> Int {
            resizeIfNecessary(with: reader)

            mapData.append(tagType.mapMarker)

            // Reserve space for the next object index and object count.
            let startIdx = mapData.count
            mapData.append(contentsOf: [0, 0])
            return startIdx
        }

        mutating func recordEndCollection(count: Int, atStartOffset startOffset: Int, with reader: DocumentReader) {
            resizeIfNecessary(with: reader)

            mapData.append(JSONMap.TypeDescriptor.collectionEnd.rawValue)

            let nextValueOffset = mapData.count
            mapData.withUnsafeMutableBufferPointer {
                $0[startOffset] = nextValueOffset
                $0[startOffset + 1] = count
            }
        }

        mutating func recordEmptyCollection(tagType: JSONMap.TypeDescriptor, with reader: DocumentReader) {
            resizeIfNecessary(with: reader)

            let nextValueOffset = mapData.count + 4
            mapData.append(contentsOf: [tagType.mapMarker, nextValueOffset, 0, JSONMap.TypeDescriptor.collectionEnd.mapMarker])
        }

        mutating func record(tagType: JSONMap.TypeDescriptor, count: Int, dataOffset: Int, with reader: DocumentReader) {
            resizeIfNecessary(with: reader)

            mapData.append(contentsOf: [tagType.mapMarker, count, dataOffset])
        }

        mutating func record(tagType: JSONMap.TypeDescriptor, with reader: DocumentReader) {
            resizeIfNecessary(with: reader)

            mapData.append(tagType.mapMarker)
        }
    }

    init(bytes: BufferView<UInt8>, options: Options) {
        self.options = options
        self.reader = DocumentReader(bytes: bytes)
    }

    mutating func scan() throws -> JSONMap {
        if options.assumesTopLevelDictionary {
            switch try reader.consumeWhitespace(allowingEOF: true) {
            case ._openbrace?:
                // If we've got the open brace anyway, just do a normal object scan.
                try scanObject()
            default:
                try scanObject(withoutBraces: true)
            }
        } else {
            try scanValue()
        }
        #if DEBUG
            defer {
                guard self.depth == 0 else {
                    preconditionFailure(
                        mobs("Expected to end parsing with a depth of 0"),
                        file: "",
                        line: 100
                    )
                }
            }
        #endif

        // ensure only white space is remaining
        var whitespace = 0
        while let next = reader.peek(offset: whitespace) {
            switch next {
            case ._space, ._tab, ._return, ._newline:
                whitespace += 1
                continue
            default:
                throw JSONError.unexpectedCharacter(context: mobs("after top-level value"), ascii: next, location: reader.sourceLocation(atOffset: whitespace))
            }
        }

        let map = JSONMap(mapBuffer: partialMap.mapData, dataBuffer: reader.bytes)

        // If the input contains only a number, we have to copy the input into a form that is guaranteed to have a trailing NUL byte so that strtod doesn't perform a buffer overrun.
        if case .number = map.loadValue(at: 0)! {
            map.copyInBuffer()
        }

        return map
    }

    // MARK: Generic Value Scanning

    mutating func scanValue() throws {
        let byte = try reader.consumeWhitespace()
        switch byte {
        case ._quote:
            try scanString()
        case ._openbrace:
            try scanObject()
        case ._openbracket:
            try scanArray()
        case UInt8(ascii: "f"), UInt8(ascii: "t"):
            try scanBool()
        case UInt8(ascii: "n"):
            try scanNull()
        case UInt8(ascii: "-"), _asciiNumbers:
            try scanNumber()
        case ._space, ._return, ._newline, ._tab:
            preconditionFailure(
                mobs("Expected that all white space is consumed"),
                file: "",
                line: 150
            )
        default:
            throw JSONError.unexpectedCharacter(ascii: byte, location: reader.sourceLocation)
        }
    }

    // MARK: - Scan Array -

    mutating func scanArray() throws {
        let firstChar = reader.read()
        precondition(firstChar == ._openbracket)
        guard depth < 512 else {
            throw JSONError.tooManyNestedArraysOrDictionaries(location: reader.sourceLocation(atOffset: 1))
        }
        depth &+= 1
        defer { depth &-= 1 }

        // parse first value or end immediately
        switch try reader.consumeWhitespace() {
        case ._space, ._return, ._newline, ._tab:
            preconditionFailure(
                mobs("Expected that all white space is consumed"),
                file: "",
                line: 174
            )
        case ._closebracket:
            // if the first char after whitespace is a closing bracket, we found an empty array
            reader.moveReaderIndex(forwardBy: 1)
            return partialMap.recordEmptyCollection(tagType: .array, with: reader)
        default:
            break
        }

        var count = 0
        let startOffset = partialMap.recordStartCollection(tagType: .array, with: reader)
        defer {
            partialMap.recordEndCollection(count: count, atStartOffset: startOffset, with: reader)
        }

        ScanValues:
            while true {
            try scanValue()
            count += 1

            // consume the whitespace after the value before the comma
            let ascii = try reader.consumeWhitespace()
            switch ascii {
            case ._space, ._return, ._newline, ._tab:
                preconditionFailure(
                    mobs("Expected that all white space is consumed"),
                    file: "",
                    line: 201
                )
            case ._closebracket:
                reader.moveReaderIndex(forwardBy: 1)
                break ScanValues
            case ._comma:
                // consume the comma
                reader.moveReaderIndex(forwardBy: 1)
                // consume the whitespace before the next value
                if try reader.consumeWhitespace() == ._closebracket {
                    // the foundation json implementation does support trailing commas
                    reader.moveReaderIndex(forwardBy: 1)
                    break ScanValues
                }
                continue
            default:
                throw JSONError.unexpectedCharacter(context: mobs("in array"), ascii: ascii, location: reader.sourceLocation)
            }
        }
    }

    // MARK: - Scan Object -

    mutating func scanObject() throws {
        let firstChar = reader.read()
        precondition(firstChar == ._openbrace)
        guard depth < 512 else {
            throw JSONError.tooManyNestedArraysOrDictionaries(location: reader.sourceLocation(atOffset: -1))
        }
        try scanObject(withoutBraces: false)
    }

    @inline(never)
    mutating func _scanObjectLoop(withoutBraces: Bool, count: inout Int, done: inout Bool) throws {
        try scanString()

        let colon = try reader.consumeWhitespace()
        guard colon == ._colon else {
            throw JSONError.unexpectedCharacter(context: mobs("in object"), ascii: colon, location: reader.sourceLocation)
        }
        reader.moveReaderIndex(forwardBy: 1)

        try scanValue()
        count += 2

        let commaOrBrace = try reader.consumeWhitespace(allowingEOF: withoutBraces)
        switch commaOrBrace {
        case ._comma?:
            reader.moveReaderIndex(forwardBy: 1)
            switch try reader.consumeWhitespace(allowingEOF: withoutBraces) {
            case ._closebrace?:
                if withoutBraces {
                    throw JSONError.unexpectedCharacter(ascii: ._closebrace, location: reader.sourceLocation)
                }

                // the foundation json implementation does support trailing commas
                reader.moveReaderIndex(forwardBy: 1)
                done = true
            case .none:
                done = true
            default:
                return
            }
        case ._closebrace?:
            if withoutBraces {
                throw JSONError.unexpectedCharacter(ascii: ._closebrace, location: reader.sourceLocation)
            }
            reader.moveReaderIndex(forwardBy: 1)
            done = true
        case .none:
            // If withoutBraces was false, then reaching EOF here would have thrown.
            precondition(withoutBraces == true)
            done = true

        default:
            throw JSONError.unexpectedCharacter(context: mobs("in object"), ascii: commaOrBrace.unsafelyUnwrapped, location: reader.sourceLocation)
        }
    }

    mutating func scanObject(withoutBraces: Bool) throws {
        depth &+= 1
        defer { depth &-= 1 }

        // parse first value or end immediately
        switch try reader.consumeWhitespace(allowingEOF: withoutBraces) {
        case ._closebrace?:
            if withoutBraces {
                throw JSONError.unexpectedCharacter(ascii: ._closebrace, location: reader.sourceLocation)
            }

            // if the first char after whitespace is a closing bracket, we found an empty object
            reader.moveReaderIndex(forwardBy: 1)
            return partialMap.recordEmptyCollection(tagType: .object, with: reader)
        case .none:
            // If withoutBraces was false, then reaching EOF here would have thrown.
            precondition(withoutBraces == true)
            return partialMap.recordEmptyCollection(tagType: .object, with: reader)
        default:
            break
        }

        var count = 0
        let startOffset = partialMap.recordStartCollection(tagType: .object, with: reader)
        defer {
            partialMap.recordEndCollection(count: count, atStartOffset: startOffset, with: reader)
        }

        var done = false
        while !done {
            try _scanObjectLoop(withoutBraces: withoutBraces, count: &count, done: &done)
        }
    }

    mutating func scanString() throws {
        var isSimple = false
        let start = try reader.skipUTF8StringTillNextUnescapedQuote(isSimple: &isSimple)
        let end = reader.readIndex

        // skipUTF8StringTillNextUnescapedQuote will have either thrown an error, or already peek'd the quote.
        let shouldBePostQuote = reader.read()
        precondition(shouldBePostQuote == ._quote)

        // skip initial quote
        return partialMap.record(tagType: isSimple ? .simpleString : .string, count: reader.distance(from: start, to: end), dataOffset: reader.byteOffset(at: start), with: reader)
    }

    mutating func scanNumber() throws {
        let start = reader.readIndex
        var containsExponent = false
        reader.skipNumber(containsExponent: &containsExponent)
        let end = reader.readIndex
        return partialMap.record(tagType: containsExponent ? .numberContainingExponent : .number, count: reader.distance(from: start, to: end), dataOffset: reader.byteOffset(at: start), with: reader)
    }

    mutating func scanBool() throws {
        if try reader.readBool() {
            return partialMap.record(tagType: .true, with: reader)
        } else {
            return partialMap.record(tagType: .false, with: reader)
        }
    }

    mutating func scanNull() throws {
        try reader.readNull()
        return partialMap.record(tagType: .null, with: reader)
    }
}

extension JSONScanner {

    struct DocumentReader {
        let bytes: BufferView<UInt8>
        private(set) var readIndex: BufferViewIndex<UInt8>
        private let endIndex: BufferViewIndex<UInt8>

        @inline(__always)
        func checkRemainingBytes(_ count: Int) -> Bool {
            bytes.distance(from: readIndex, to: endIndex) >= count
        }

        @inline(__always)
        func requireRemainingBytes(_ count: Int) throws {
            guard checkRemainingBytes(count) else {
                throw JSONError.unexpectedEndOfFile
            }
        }

        var sourceLocation: JSONError.SourceLocation {
            self.sourceLocation(atOffset: 0)
        }

        func sourceLocation(atOffset offset: Int) -> JSONError.SourceLocation {
            .sourceLocation(at: bytes.index(readIndex, offsetBy: offset), fullSource: bytes)
        }

        @inline(__always)
        var isEOF: Bool {
            readIndex == endIndex
        }

        @inline(__always)
        func byteOffset(at index: BufferViewIndex<UInt8>) -> Int {
            bytes.distance(from: bytes.startIndex, to: index)
        }

        init(bytes: BufferView<UInt8>) {
            self.bytes = bytes
            self.readIndex = bytes.startIndex
            self.endIndex = bytes.endIndex
        }

        @inline(__always)
        mutating func read() -> UInt8? {
            guard !isEOF else {
                return nil
            }

            defer { bytes.formIndex(after: &readIndex) }

            return bytes[unchecked: readIndex]
        }

        @inline(__always)
        func peek(offset: Int = 0) -> UInt8? {
            precondition(offset >= 0)
            assert(bytes.startIndex <= readIndex)
            let peekIndex = bytes.index(readIndex, offsetBy: offset)
            guard peekIndex < endIndex else {
                return nil
            }

            return bytes[unchecked: peekIndex]
        }

        @inline(__always)
        mutating func moveReaderIndex(forwardBy offset: Int) {
            bytes.formIndex(&readIndex, offsetBy: offset)
        }

        @inline(__always)
        func distance(from start: BufferViewIndex<UInt8>, to end: BufferViewIndex<UInt8>) -> Int {
            bytes.distance(from: start, to: end)
        }

        static var whitespaceBitmap: UInt64 { 1 << UInt8._space | 1 << UInt8._return | 1 << UInt8._newline | 1 << UInt8._tab }

        @inline(__always)
        @discardableResult
        mutating func consumeWhitespace() throws -> UInt8 {
            assert(bytes.startIndex <= readIndex)
            while readIndex < endIndex {
                let ascii = bytes[unchecked: readIndex]
                if Self.whitespaceBitmap & (1 << ascii) != 0 {
                    bytes.formIndex(after: &readIndex)
                    continue
                } else {
                    return ascii
                }
            }

            throw JSONError.unexpectedEndOfFile
        }

        @inline(__always)
        @discardableResult
        mutating func consumeWhitespace(allowingEOF: Bool) throws -> UInt8? {
            assert(bytes.startIndex <= readIndex)
            while readIndex < endIndex {
                let ascii = bytes[unchecked: readIndex]
                if Self.whitespaceBitmap & (1 << ascii) != 0 {
                    bytes.formIndex(after: &readIndex)
                    continue
                } else {
                    return ascii
                }
            }
            guard allowingEOF else {
                throw JSONError.unexpectedEndOfFile
            }
            return nil
        }

        @inline(__always)
        mutating func readExpectedString(_ str: StaticString, typeDescriptor: String) throws {
            let cmp = try bytes[unchecked: readIndex ..< endIndex].withUnsafeRawPointer { ptr, count in
                if count < str.utf8CodeUnitCount { throw JSONError.unexpectedEndOfFile }
                return memcmp(ptr, str.utf8Start, str.utf8CodeUnitCount)
            }
            guard cmp == 0 else {
                // Figure out the exact character that is wrong.
                let badOffset = str.withUTF8Buffer {
                    for (i, (a, b)) in zip($0, bytes[readIndex ..< endIndex]).enumerated() {
                        if a != b { return i }
                    }
                    return 0 // should be unreachable
                }
                moveReaderIndex(forwardBy: badOffset)
                throw JSONError.unexpectedCharacter(context: mobs("in expected \(typeDescriptor) value"), ascii: peek()!, location: sourceLocation)
            }

            // If all looks good, advance past the string.
            moveReaderIndex(forwardBy: str.utf8CodeUnitCount)
        }

        @inline(__always)
        mutating func readBool() throws -> Bool {
            switch read() {
            case UInt8(ascii: "t"):
                try readExpectedString("rue", typeDescriptor: mobs("boolean"))
                return true
            case UInt8(ascii: "f"):
                try readExpectedString("alse", typeDescriptor: mobs("boolean"))
                return false
            default:
                preconditionFailure(
                    mobs("Expected to have `t` or `f` as first character"),
                    file: "",
                    line: 498
                )
            }
        }

        @inline(__always)
        mutating func readNull() throws {
            try readExpectedString("null", typeDescriptor: "null")
        }

        // MARK: - Private Methods -

        // MARK: String

        mutating func skipUTF8StringTillQuoteOrBackslashOrInvalidCharacter() throws -> UInt8 {
            while let byte = self.peek() {
                switch byte {
                case ._quote, ._backslash:
                    return byte
                default:
                    // Any control characters in the 0-31 range are invalid. Any other characters will have at least one bit in a 0xe0 mask.
                    guard _fastPath(byte & 0xE0 != 0) else {
                        return byte
                    }
                    moveReaderIndex(forwardBy: 1)
                }
            }
            throw JSONError.unexpectedEndOfFile
        }

        mutating func skipUTF8StringTillNextUnescapedQuote(isSimple: inout Bool) throws -> BufferViewIndex<UInt8> {
            // Skip the open quote.
            guard let shouldBeQuote = self.read() else {
                throw JSONError.unexpectedEndOfFile
            }
            guard shouldBeQuote == ._quote else {
                throw JSONError.unexpectedCharacter(ascii: shouldBeQuote, location: sourceLocation)
            }
            let firstNonQuote = readIndex

            // If there aren't any escapes, then this is a simple case and we can exit early.
            if try skipUTF8StringTillQuoteOrBackslashOrInvalidCharacter() == ._quote {
                isSimple = true
                return firstNonQuote
            }

            while let byte = self.peek() {
                // Checking for invalid control characters deferred until parse time.
                switch byte {
                case ._quote:
                    isSimple = false
                    return firstNonQuote
                case ._backslash:
                    try skipEscapeSequence()
                default:
                    moveReaderIndex(forwardBy: 1)
                    continue
                }
            }
            throw JSONError.unexpectedEndOfFile
        }

        private mutating func skipEscapeSequence() throws {
            let firstChar = read()
            precondition(
                firstChar == ._backslash,
                mobs("Expected to have a backslash first"),
                file: "",
                line: 566
            )

            guard let ascii = self.read() else {
                throw JSONError.unexpectedEndOfFile
            }

            // Invalid escaped characters checking deferred to parse time.
            if ascii == UInt8(ascii: "u") {
                try skipUnicodeHexSequence()
            }
        }

        private mutating func skipUnicodeHexSequence() throws {
            // As stated in RFC-8259 an escaped unicode character is 4 HEXDIGITs long
            // https://tools.ietf.org/html/rfc8259#section-7
            try requireRemainingBytes(4)

            // We'll validate the actual characters following the '\u' escape during parsing. Just make sure that the string doesn't end prematurely.
            let hs = bytes.loadUnaligned(from: readIndex, as: UInt32.self)
            guard JSONScanner.noByteMatches(UInt8(ascii: "\""), in: hs) else {
                let hexString = _withUnprotectedUnsafeBytes(of: hs) { String(decoding: $0, as: UTF8.self) }
                throw JSONError.invalidHexDigitSequence(hexString, location: sourceLocation)
            }
            moveReaderIndex(forwardBy: 4)
        }

        // MARK: Numbers

        mutating func skipNumber(containsExponent: inout Bool) {
            guard let ascii = read() else {
                preconditionFailure(
                    mobs("Why was this function called, if there is no 0...9 or -"),
                    file: "",
                    line: 600
                )
            }
            switch ascii {
            case _asciiNumbers, UInt8(ascii: "-"):
                break
            default:
                preconditionFailure(
                    mobs("Why was this function called, if there is no 0...9 or -"),
                    file: "",
                    line: 610
                )
            }
            while let byte = peek() {
                if _fastPath(_asciiNumbers.contains(byte)) {
                    moveReaderIndex(forwardBy: 1)
                    continue
                }
                switch byte {
                case UInt8(ascii: "."), UInt8(ascii: "+"), UInt8(ascii: "-"):
                    moveReaderIndex(forwardBy: 1)
                case UInt8(ascii: "e"), UInt8(ascii: "E"):
                    moveReaderIndex(forwardBy: 1)
                    containsExponent = true
                default:
                    return
                }
            }
        }
    }

    @inline(__always)
    internal static func noByteMatches(_ asciiByte: UInt8, in hexString: UInt32) -> Bool {
        assert(asciiByte & 0x80 == 0)
        // Copy asciiByte of interest to mask.
        let t0 = UInt32(0x0101_0101) &* UInt32(asciiByte)
        // xor input and mask, then locate potential matches.
        let t1 = ((hexString ^ t0) & 0x7F7F_7F7F) &+ 0x7F7F_7F7F
        // Positions with matches are 0x7f.
        // Positions with non-matching ascii bytes have their MSB set.
        // Positions with non-ascii bytes do not have their MSB set.
        // Eliminate non-ascii bytes with a bitwise-or of t1 with the input,
        // then select the positions whose MSB is not set.
        let t2 = ((hexString | t1) & 0x8080_8080) ^ 0x8080_8080
        // There is no match when no bit is set.
        return t2 == 0
    }
}

// MARK: - Deferred Parsing Methods -

extension JSONScanner {

    // MARK: String

    static func stringValue(
        from jsonBytes: BufferView<UInt8>, fullSource: BufferView<UInt8>
    ) throws -> String {
        // Assume easy path first -- no escapes, no characters requiring escapes.
        var index = jsonBytes.startIndex
        let endIndex = jsonBytes.endIndex
        while index < endIndex {
            let byte = jsonBytes[unchecked: index]
            guard byte != ._backslash, _fastPath(byte & 0xE0 != 0) else { break }
            jsonBytes.formIndex(after: &index)
        }

        guard var output = String._tryFromUTF8(jsonBytes[unchecked: jsonBytes.startIndex ..< index]) else {
            throw JSONError.cannotConvertInputStringDataToUTF8(location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
        }
        if _fastPath(index == endIndex) {
            // We went through all the characters! Easy peasy.
            return output
        }

        let remainingBytes = jsonBytes[unchecked: index ..< endIndex]
        try _slowpath_stringValue(from: remainingBytes, appendingTo: &output, fullSource: fullSource)
        return output
    }

    static func _slowpath_stringValue(
        from jsonBytes: BufferView<UInt8>, appendingTo output: inout String, fullSource: BufferView<UInt8>
    ) throws {
        // Continue scanning, taking into account escaped sequences and control characters
        var index = jsonBytes.startIndex
        var chunkStart = index
        while index < jsonBytes.endIndex {
            let byte = jsonBytes[unchecked: index]
            switch byte {
            case ._backslash:
                guard let stringChunk = String._tryFromUTF8(jsonBytes[unchecked: chunkStart ..< index]) else {
                    throw JSONError.cannotConvertInputStringDataToUTF8(location: .sourceLocation(at: chunkStart, fullSource: fullSource))
                }
                output += stringChunk

                // Advance past the backslash
                jsonBytes.formIndex(after: &index)

                index = try parseEscapeSequence(from: jsonBytes.suffix(from: index), into: &output, fullSource: fullSource)
                chunkStart = index

            default:
                guard _fastPath(byte & 0xE0 != 0) else {
                    // All Unicode characters may be placed within the quotation marks, except for the characters that must be escaped: quotation mark, reverse solidus, and the control characters (U+0000 through U+001F).
                    throw JSONError.unescapedControlCharacterInString(ascii: byte, location: .sourceLocation(at: index, fullSource: fullSource))
                }

                jsonBytes.formIndex(after: &index)
                continue
            }
        }

        guard let stringChunk = String._tryFromUTF8(jsonBytes[unchecked: chunkStart ..< index]) else {
            throw JSONError.cannotConvertInputStringDataToUTF8(location: .sourceLocation(at: chunkStart, fullSource: fullSource))
        }
        output += stringChunk
    }

    private static func parseEscapeSequence(
        from jsonBytes: BufferView<UInt8>, into string: inout String, fullSource: BufferView<UInt8>
    ) throws -> BufferViewIndex<UInt8> {
        precondition(
            !jsonBytes.isEmpty,
            mobs("Scanning should have ensured that all escape sequences are valid shape"),
            file: "",
            line: 726
        )
        switch jsonBytes[unchecked: jsonBytes.startIndex] {
        case UInt8(ascii: "\""): string.append("\"")
        case UInt8(ascii: "\\"): string.append("\\")
        case UInt8(ascii: "/"): string.append("/")
        case UInt8(ascii: "b"): string.append("\u{08}") // \b
        case UInt8(ascii: "f"): string.append("\u{0C}") // \f
        case UInt8(ascii: "n"): string.append("\u{0A}") // \n
        case UInt8(ascii: "r"): string.append("\u{0D}") // \r
        case UInt8(ascii: "t"): string.append("\u{09}") // \t
        case UInt8(ascii: "u"):
            return try parseUnicodeSequence(from: jsonBytes.dropFirst(), into: &string, fullSource: fullSource)
        case let ascii: // default
            throw JSONError.unexpectedEscapedCharacter(ascii: ascii, location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
        }
        return jsonBytes.index(after: jsonBytes.startIndex)
    }

    // Shared with JSON5, which requires allowNulls = false for compatibility.
    internal static func parseUnicodeSequence(
        from jsonBytes: BufferView<UInt8>, into string: inout String, fullSource: BufferView<UInt8>, allowNulls: Bool = true
    ) throws -> BufferViewIndex<UInt8> {
        // we build this for utf8 only for now.
        let (bitPattern, index1) = try parseUnicodeHexSequence(from: jsonBytes, fullSource: fullSource, allowNulls: allowNulls)

        // check if lead surrogate
        if UTF16.isLeadSurrogate(bitPattern) {
            // if we have a lead surrogate we expect a trailing surrogate next
            let leadingSurrogateBitPattern = bitPattern
            var trailingBytes = jsonBytes.suffix(from: index1)
            guard trailingBytes.count >= 2 else {
                throw JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location: .sourceLocation(at: index1, fullSource: fullSource))
            }
            guard trailingBytes[uncheckedOffset: 0] == ._backslash,
                trailingBytes[uncheckedOffset: 1] == UInt8(ascii: "u")
            else {
                throw JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location: .sourceLocation(at: index1, fullSource: fullSource))
            }
            trailingBytes = trailingBytes.dropFirst(2)

            let (trailingSurrogateBitPattern, index2) = try parseUnicodeHexSequence(from: trailingBytes, fullSource: fullSource, allowNulls: true)
            guard UTF16.isTrailSurrogate(trailingSurrogateBitPattern) else {
                throw JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location: .sourceLocation(at: trailingBytes.startIndex, fullSource: fullSource))
            }

            let encodedScalar = UTF16.EncodedScalar([leadingSurrogateBitPattern, trailingSurrogateBitPattern])
            let unicode = UTF16.decode(encodedScalar)
            string.unicodeScalars.append(unicode)
            return index2
        } else {
            guard let unicode = Unicode.Scalar(bitPattern) else {
                throw JSONError.couldNotCreateUnicodeScalarFromUInt32(location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource), unicodeScalarValue: UInt32(bitPattern))
            }
            string.unicodeScalars.append(unicode)
            return index1
        }
    }

    internal static func parseUnicodeHexSequence(
        from jsonBytes: BufferView<UInt8>, fullSource: BufferView<UInt8>, allowNulls: Bool = true
    ) throws -> (scalar: UInt16, nextIndex: BufferViewIndex<UInt8>) {
        let digitBytes = jsonBytes.prefix(4)
        precondition(
            digitBytes.count == 4,
            mobs("Scanning should have ensured that all escape sequences are valid shape"),
            file: "",
            line: 793
        )

        guard let result: UInt16 = _parseHexIntegerDigits(digitBytes, isNegative: false)
        else {
            let hexString = String(decoding: digitBytes, as: Unicode.UTF8.self)
            throw JSONError.invalidHexDigitSequence(hexString, location: .sourceLocation(at: digitBytes.startIndex, fullSource: fullSource))
        }
        guard allowNulls || result != 0 else {
            throw JSONError.invalidEscapedNullValue(location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
        }
        assert(digitBytes.endIndex <= jsonBytes.endIndex)
        return (result, digitBytes.endIndex)
    }

    // MARK: Numbers

    static func validateLeadingZero(in jsonBytes: BufferView<UInt8>, fullSource: BufferView<UInt8>) throws {
        // Leading zeros are very restricted.
        if jsonBytes.isEmpty {
            // Yep, this is valid.
            return
        }
        switch jsonBytes[uncheckedOffset: 0] {
        case UInt8(ascii: "."), UInt8(ascii: "e"), UInt8(ascii: "E"):
            // This is valid after a leading zero.
            return
        case _asciiNumbers:
            throw JSONError.numberWithLeadingZero(location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
        case let byte: // default
            throw JSONError.unexpectedCharacter(context: mobs("in number"), ascii: byte, location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
        }
    }

    // Returns the pointer at which the number's digits begin. If there are no digits, the function throws.
    static func prevalidateJSONNumber(
        from jsonBytes: BufferView<UInt8>, hasExponent: Bool, fullSource: BufferView<UInt8>
    ) throws -> BufferViewIndex<UInt8> {
        // Just make sure we (A) don't have a leading zero, and (B) We have at least one digit.
        guard !jsonBytes.isEmpty else {
            preconditionFailure(
                mobs("Why was this function called, if there is no 0...9 or -"),
                file: "",
                line: 835
            )
        }
        let firstDigitIndex: BufferViewIndex<UInt8>
        switch jsonBytes[uncheckedOffset: 0] {
        case UInt8(ascii: "0"):
            try validateLeadingZero(in: jsonBytes.dropFirst(1), fullSource: fullSource)
            firstDigitIndex = jsonBytes.startIndex
        case UInt8(ascii: "1") ... UInt8(ascii: "9"):
            firstDigitIndex = jsonBytes.startIndex
        case UInt8(ascii: "-"):
            guard jsonBytes.count > 1 else {
                throw JSONError.unexpectedCharacter(context: mobs("at end of number"), ascii: UInt8(ascii: "-"), location: .sourceLocation(at: jsonBytes.startIndex, fullSource: fullSource))
            }
            switch jsonBytes[uncheckedOffset: 1] {
            case UInt8(ascii: "0"):
                try validateLeadingZero(in: jsonBytes.dropFirst(2), fullSource: fullSource)
            case UInt8(ascii: "1") ... UInt8(ascii: "9"):
                // Good, we need at least one digit following the '-'
                break
            case let byte: // default
                // Any other character is invalid.
                throw JSONError.unexpectedCharacter(context: mobs("after '-' in number"), ascii: byte, location: .sourceLocation(at: jsonBytes.index(after: jsonBytes.startIndex), fullSource: fullSource))
            }
            firstDigitIndex = jsonBytes.index(after: jsonBytes.startIndex)
        default:
            preconditionFailure(
                mobs("Why was this function called, if there is no 0...9 or -"),
                file: "",
                line: 865
            )
        }

        // If the number was found to have an exponent, we have to guarantee that there are digits preceding it, which is a JSON requirement. If we don't, then our floating point parser, which is tolerant of that construction, will succeed and not produce the required error.
        if hasExponent {
            var index = jsonBytes.index(after: firstDigitIndex)
            exponentLoop: while index < jsonBytes.endIndex {
                switch jsonBytes[unchecked: index] {
                case UInt8(ascii: "e"), UInt8(ascii: "E"):
                    let previous = jsonBytes.index(before: index)
                    guard case _asciiNumbers = jsonBytes[unchecked: previous] else {
                        throw JSONError.unexpectedCharacter(context: mobs("in number"), ascii: jsonBytes[index], location: .sourceLocation(at: index, fullSource: fullSource))
                    }
                    // We're done iterating.
                    break exponentLoop
                default:
                    jsonBytes.formIndex(after: &index)
                }
            }
        }

        let lastIndex = jsonBytes.index(before: jsonBytes.endIndex)
        assert(lastIndex >= jsonBytes.startIndex)
        switch jsonBytes[unchecked: lastIndex] {
        case _asciiNumbers:
            break // In JSON, all numbers must end with a digit.
        case let lastByte: // default
            throw JSONError.unexpectedCharacter(context: mobs("at end of number"), ascii: lastByte, location: .sourceLocation(at: lastIndex, fullSource: fullSource))
        }
        return firstDigitIndex
    }

    // This function is intended to be called after prevalidateJSONNumber() (which provides the digitsBeginPtr) and after parsing fails. It will provide more useful information about the invalid input.
    static func validateNumber(from jsonBytes: BufferView<UInt8>, fullSource: BufferView<UInt8>) -> JSONError {
        enum ControlCharacter {
            case operand
            case decimalPoint
            case exp
            case expOperator
        }

        var index = jsonBytes.startIndex
        let endIndex = jsonBytes.endIndex
        // Fast-path, assume all digits.
        while index < endIndex {
            guard _asciiNumbers.contains(jsonBytes[index]) else { break }
            jsonBytes.formIndex(after: &index)
        }

        var pastControlChar: ControlCharacter = .operand
        var digitsSinceControlChar = jsonBytes.distance(from: jsonBytes.startIndex, to: index)

        // parse everything else
        while index < endIndex {
            let byte = jsonBytes[index]
            switch byte {
            case _asciiNumbers:
                digitsSinceControlChar += 1
            case UInt8(ascii: "."):
                guard digitsSinceControlChar > 0, pastControlChar == .operand else {
                    return JSONError.unexpectedCharacter(context: mobs("in number"), ascii: byte, location: .sourceLocation(at: index, fullSource: fullSource))
                }
                pastControlChar = .decimalPoint
                digitsSinceControlChar = 0

            case UInt8(ascii: "e"), UInt8(ascii: "E"):
                guard digitsSinceControlChar > 0,
                    pastControlChar == .operand || pastControlChar == .decimalPoint
                else {
                    return JSONError.unexpectedCharacter(context: mobs("in number"), ascii: byte, location: .sourceLocation(at: index, fullSource: fullSource))
                }
                pastControlChar = .exp
                digitsSinceControlChar = 0

            case UInt8(ascii: "+"), UInt8(ascii: "-"):
                guard digitsSinceControlChar == 0, pastControlChar == .exp else {
                    return JSONError.unexpectedCharacter(context: mobs("in number"), ascii: byte, location: .sourceLocation(at: index, fullSource: fullSource))
                }
                pastControlChar = .expOperator
                digitsSinceControlChar = 0

            default:
                return JSONError.unexpectedCharacter(context: mobs("in number"), ascii: byte, location: .sourceLocation(at: index, fullSource: fullSource))
            }
            jsonBytes.formIndex(after: &index)
        }

        if digitsSinceControlChar > 0 {
            preconditionFailure(
                mobs("Invalid number expected in validateNumber(from:fullSource:). Input code unit buffer contained valid input."),
                file: "",
                line: 957
            )
        } else { // prevalidateJSONNumber() already checks for trailing `e`/`E` characters.
            preconditionFailure(
                mobs("Found trailing non-digit. Number character buffer was not validated with prevalidateJSONNumber()"),
                file: "",
                line: 963
            )
        }
    }
}

internal
func _parseHexIntegerDigits<Result: FixedWidthInteger>(
    _ codeUnits: BufferView<UInt8>, isNegative: Bool
) -> Result? {
    guard _fastPath(!codeUnits.isEmpty) else { return nil }

    // ASCII constants, named for clarity:
    let _0 = 48 as UInt8, _A = 65 as UInt8, _a = 97 as UInt8

    let numericalUpperBound = _0 &+ 10
    let uppercaseUpperBound = _A &+ 6
    let lowercaseUpperBound = _a &+ 6
    let multiplicand: Result = 16

    var result = 0 as Result
    for digit in codeUnits {
        let digitValue: Result
        if _fastPath(digit >= _0 && digit < numericalUpperBound) {
            digitValue = Result(truncatingIfNeeded: digit &- _0)
        } else if _fastPath(digit >= _A && digit < uppercaseUpperBound) {
            digitValue = Result(truncatingIfNeeded: digit &- _A &+ 10)
        } else if _fastPath(digit >= _a && digit < lowercaseUpperBound) {
            digitValue = Result(truncatingIfNeeded: digit &- _a &+ 10)
        } else {
            return nil
        }

        let overflow1: Bool
        (result, overflow1) = result.multipliedReportingOverflow(by: multiplicand)
        let overflow2: Bool
        (result, overflow2) = isNegative
            ? result.subtractingReportingOverflow(digitValue)
            : result.addingReportingOverflow(digitValue)
        guard _fastPath(!overflow1 && !overflow2) else { return nil }
    }
    return result
}

// swiftlint:enable all
