import Foundation


// swiftlint:disable all
open class FastJSONEncoder: JSONEncoder {
    // MARK: Options

    /// The output format to produce. Defaults to `[]`.
    open override var outputFormatting: OutputFormatting {
        get {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            return options.outputFormatting
        }
        _modify {
            optionsLock.lock()
            var value = options.outputFormatting
            defer {
                options.outputFormatting = value
                optionsLock.unlock()
            }
            yield &value
        }
        set {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            options.outputFormatting = newValue
        }
    }

    /// The strategy to use in encoding dates. Defaults to `.deferredToDate`.
    open override var dateEncodingStrategy: DateEncodingStrategy {
        get {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            return options.dateEncodingStrategy
        }
        _modify {
            optionsLock.lock()
            var value = options.dateEncodingStrategy
            defer {
                options.dateEncodingStrategy = value
                optionsLock.unlock()
            }
            yield &value
        }
        set {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            options.dateEncodingStrategy = newValue
        }
    }

    /// The strategy to use in encoding binary data. Defaults to `.base64`.
    open override var dataEncodingStrategy: DataEncodingStrategy {
        get {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            return options.dataEncodingStrategy
        }
        _modify {
            optionsLock.lock()
            var value = options.dataEncodingStrategy
            defer {
                options.dataEncodingStrategy = value
                optionsLock.unlock()
            }
            yield &value
        }
        set {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            options.dataEncodingStrategy = newValue
        }
    }

    /// The strategy to use in encoding non-conforming numbers. Defaults to `.throw`.
    open override var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy {
        get {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            return options.nonConformingFloatEncodingStrategy
        }
        _modify {
            optionsLock.lock()
            var value = options.nonConformingFloatEncodingStrategy
            defer {
                options.nonConformingFloatEncodingStrategy = value
                optionsLock.unlock()
            }
            yield &value
        }
        set {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            options.nonConformingFloatEncodingStrategy = newValue
        }
    }

    /// The strategy to use for encoding keys. Defaults to `.useDefaultKeys`.
    open override var keyEncodingStrategy: KeyEncodingStrategy {
        get {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            return options.keyEncodingStrategy
        }
        _modify {
            optionsLock.lock()
            var value = options.keyEncodingStrategy
            defer {
                options.keyEncodingStrategy = value
                optionsLock.unlock()
            }
            yield &value
        }
        set {
            optionsLock.lock()
            defer { optionsLock.unlock() }
            options.keyEncodingStrategy = newValue
        }
    }

    /// Contextual user-provided information for use during encoding.
    #if compiler(>=6.1.0)
        open override var userInfo: [CodingUserInfoKey: any Sendable] {
            get {
                optionsLock.lock()
                defer { optionsLock.unlock() }
                return options.userInfo
            }
            _modify {
                optionsLock.lock()
                var value = options.userInfo
                defer {
                    options.userInfo = value
                    optionsLock.unlock()
                }
                yield &value
            }
            set {
                optionsLock.lock()
                defer { optionsLock.unlock() }
                options.userInfo = newValue
            }
        }

    #else
        open override var userInfo: [CodingUserInfoKey: Any] {
            get {
                optionsLock.lock()
                defer { optionsLock.unlock() }
                return options.userInfo
            }
            _modify {
                optionsLock.lock()
                var value = options.userInfo
                defer {
                    options.userInfo = value
                    optionsLock.unlock()
                }
                yield &value
            }
            set {
                optionsLock.lock()
                defer { optionsLock.unlock() }
                options.userInfo = newValue
            }
        }
    #endif

    /// Options set on the top-level encoder to pass down the encoding hierarchy.
    fileprivate struct _Options {
        var outputFormatting: OutputFormatting = []
        var dateEncodingStrategy: DateEncodingStrategy = .deferredToDate
        var dataEncodingStrategy: DataEncodingStrategy = .base64
        var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw
        var keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys
        #if compiler(>=6.1.0)
            var userInfo: [CodingUserInfoKey: any Sendable] = [:]
        #else
            var userInfo: [CodingUserInfoKey: Any] = [:]
        #endif
    }

    /// The options set on the top-level encoder.
    fileprivate var options = _Options()
    fileprivate let optionsLock = LockedState<Void>()

    // MARK: - Encoding Values

    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    open override func encode<T: Encodable>(_ value: T) throws -> Data {
        try _encode({
            try $0.wrapGeneric(value)
        }, value: value)
    }

    private func _encode<T>(_ wrap: (__JSONEncoder) throws -> JSONEncoderValue?, value: T) throws -> Data {
        let encoder = __JSONEncoder(options: options, ownerEncoder: nil)

        guard let topLevel = try wrap(encoder) else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [], debugDescription: mobs("Top-level \(T.self) did not encode any values."))
            )
        }

        let writingOptions = outputFormatting
        do {
            var writer = JSONWriter(options: writingOptions)
            try writer.serializeJSON(topLevel)
            return Data(writer.bytes)
        } catch let error as JSONError {
            let underlyingError: Error? = error.nsError

            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [], debugDescription: mobs("Unable to encode the given top-level value to JSON."), underlyingError: underlyingError)
            )
        }
    }
}

// MARK: - __JSONEncoder

// NOTE: older overlays called this class _JSONEncoder.
// The two must coexist without a conflicting ObjC class name, so it
// was renamed. The old name must not be used in the new runtime.
private class __JSONEncoder: Encoder {
    // MARK: Properties

    /// The encoder's storage.
    var singleValue: JSONEncoderValue?
    var array: JSONFuture.RefArray?
    var object: JSONFuture.RefObject?

    func takeValue() -> JSONEncoderValue? {
        if let object = self.object {
            self.object = nil
            return .object(object.values)
        }
        if let array = self.array {
            self.array = nil
            return .array(array.values)
        }
        defer {
            self.singleValue = nil
        }
        return singleValue
    }

    /// Options set on the top-level encoder.
    fileprivate let options: FastJSONEncoder._Options

    var ownerEncoder: __JSONEncoder?
    var sharedSubEncoder: __JSONEncoder?
    var codingKey: (any CodingKey)?

    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey: Any] {
        return options.userInfo
    }

    /// The path to the current point in encoding.
    public var codingPath: [CodingKey] {
        var result = [any CodingKey]()
        var encoder = self
        if let codingKey {
            result.append(codingKey)
        }

        while let ownerEncoder = encoder.ownerEncoder,
            let key = ownerEncoder.codingKey {
            result.append(key)
            encoder = ownerEncoder
        }

        return result.reversed()
    }

    // MARK: - Initialization

    /// Initializes `self` with the given top-level encoder options.
    init(options: FastJSONEncoder._Options, ownerEncoder: __JSONEncoder?, codingKey: (any CodingKey)? = _CodingKey?.none) {
        self.options = options
        self.ownerEncoder = ownerEncoder
        self.codingKey = codingKey
    }

    // MARK: - Encoder Methods

    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        // If an existing keyed container was already requested, return that one.
        if let object {
            let container = _JSONKeyedEncodingContainer<Key>(referencing: self, codingPathNode: .root, wrapping: object)
            return KeyedEncodingContainer(container)
        }
        if let object = self.singleValue?.convertedToObjectRef() {
            singleValue = nil
            self.object = object

            let container = _JSONKeyedEncodingContainer<Key>(referencing: self, codingPathNode: .root, wrapping: object)
            return KeyedEncodingContainer(container)
        }

        guard singleValue == nil, array == nil else {
            preconditionFailure(
                mobs("Attempt to push new keyed encoding container when already previously encoded at this path."),
                file: "",
                line: 315
            )
        }

        let newObject = JSONFuture.RefObject()
        object = newObject
        let container = _JSONKeyedEncodingContainer<Key>(referencing: self, codingPathNode: .root, wrapping: newObject)
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        // If an existing unkeyed container was already requested, return that one.
        if let array {
            return _JSONUnkeyedEncodingContainer(referencing: self, codingPathNode: .root, wrapping: array)
        }
        if let array = self.singleValue?.convertedToArrayRef() {
            singleValue = nil
            self.array = array

            return _JSONUnkeyedEncodingContainer(referencing: self, codingPathNode: .root, wrapping: array)
        }

        guard singleValue == nil, object == nil else {
            preconditionFailure(
                mobs("Attempt to push new unkeyed encoding container when already previously encoded at this path."),
                file: "",
                line: 340
            )
        }

        let newArray = JSONFuture.RefArray()
        array = newArray
        return _JSONUnkeyedEncodingContainer(referencing: self, codingPathNode: .root, wrapping: newArray)
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

// MARK: - Encoding Containers

private struct _JSONKeyedEncodingContainer<K> {
    typealias Key = K

    // MARK: Properties

    /// A reference to the encoder we're writing to.
    private let encoder: __JSONEncoder

    private let reference: JSONFuture.RefObject
    private let codingPathNode: _CodingPathNode

    /// The path of coding keys taken to get to this point in encoding.
    public var codingPath: [CodingKey] {
        encoder.codingPath + codingPathNode.path
    }

    // MARK: - Initialization

    /// Initializes `self` with the given references.
    init(referencing encoder: __JSONEncoder, codingPathNode: _CodingPathNode, wrapping ref: JSONFuture.RefObject) {
        self.encoder = encoder
        self.codingPathNode = codingPathNode
        self.reference = ref
    }
}

extension _JSONKeyedEncodingContainer: KeyedEncodingContainerProtocol where K: CodingKey {

    // MARK: - Coding Path Operations

    private func _converted(_ key: CodingKey) -> String {
        switch encoder.options.keyEncodingStrategy {
        case .useDefaultKeys:
            return key.stringValue
        case .convertToSnakeCase:
            let newKeyString = JSONEncoder.KeyEncodingStrategy._convertToSnakeCase(key.stringValue)
            return newKeyString
        case let .custom(converter):
            var path = codingPath
            path.append(key)
            return converter(path).stringValue
        @unknown default:
            fatalError()
        }
    }

    // MARK: - KeyedEncodingContainerProtocol Methods

    func encodeNil(forKey key: Key) throws {
        reference.set(.null, for: _converted(key))
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    func encode(_ value: Int, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: Int8, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: Int16, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: Int32, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: Int64, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    mutating func encode(_ value: Int128, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: UInt, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    mutating func encode(_ value: UInt128, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: String, forKey key: Key) throws {
        reference.set(encoder.wrap(value), for: _converted(key))
    }

    mutating func encode(_ value: Float, forKey key: Key) throws {
        let wrapped = try encoder.wrap(value, for: key)
        reference.set(wrapped, for: _converted(key))
    }

    mutating func encode(_ value: Double, forKey key: Key) throws {
        let wrapped = try encoder.wrap(value, for: key)
        reference.set(wrapped, for: _converted(key))
    }

    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        let wrapped = try encoder.wrap(value, for: key)
        reference.set(wrapped, for: _converted(key))
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let containerKey = _converted(key)
        let nestedRef: JSONFuture.RefObject
        if let existingRef = self.reference.dict[containerKey] {
            if let object = existingRef.object {
                // Was encoded as an object ref previously. We can just use it again.
                nestedRef = object
            } else if case let .value(value) = existingRef,
                let convertedObject = value.convertedToObjectRef() {
                // Was encoded as an object *value* previously. We need to convert it back to a reference before we can use it.
                nestedRef = convertedObject
                self.reference.dict[containerKey] = .nestedObject(convertedObject)
            } else {
                preconditionFailure(
                    mobs("Attempt to re-encode into nested KeyedEncodingContainer<\(Key.self)> for key \"\(containerKey)\" is invalid: non-keyed container already encoded for this key"),
                    file: "",
                    line: 496
                )
            }
        } else {
            nestedRef = reference.setObject(for: containerKey)
        }

        let container = _JSONKeyedEncodingContainer<NestedKey>(referencing: encoder, codingPathNode: codingPathNode.appending(key), wrapping: nestedRef)
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let containerKey = _converted(key)
        let nestedRef: JSONFuture.RefArray
        if let existingRef = self.reference.dict[containerKey] {
            if let array = existingRef.array {
                // Was encoded as an array ref previously. We can just use it again.
                nestedRef = array
            } else if case let .value(value) = existingRef,
                let convertedArray = value.convertedToArrayRef() {
                // Was encoded as an array *value* previously. We need to convert it back to a reference before we can use it.
                nestedRef = convertedArray
                self.reference.dict[containerKey] = .nestedArray(convertedArray)
            } else {
                preconditionFailure(
                    mobs("Attempt to re-encode into nested UnkeyedEncodingContainer for key \"\(containerKey)\" is invalid: keyed container/single value already encoded for this key"),
                    file: "",
                    line: 523
                )
            }
        } else {
            nestedRef = reference.setArray(for: containerKey)
        }

        return _JSONUnkeyedEncodingContainer(referencing: encoder, codingPathNode: codingPathNode.appending(key), wrapping: nestedRef)
    }

    mutating func superEncoder() -> Encoder {
        return __JSONReferencingEncoder(referencing: encoder, key: _CodingKey.super, convertedKey: _converted(_CodingKey.super), wrapping: reference)
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
        return __JSONReferencingEncoder(referencing: encoder, key: key, convertedKey: _converted(key), wrapping: reference)
    }
}

private struct _JSONUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    // MARK: Properties

    /// A reference to the encoder we're writing to.
    private let encoder: __JSONEncoder

    private let reference: JSONFuture.RefArray
    private let codingPathNode: _CodingPathNode

    /// The path of coding keys taken to get to this point in encoding.
    public var codingPath: [CodingKey] {
        encoder.codingPath + codingPathNode.path
    }

    /// The number of elements encoded into the container.
    public var count: Int {
        reference.array.count
    }

    // MARK: - Initialization

    /// Initializes `self` with the given references.
    init(referencing encoder: __JSONEncoder, codingPathNode: _CodingPathNode, wrapping ref: JSONFuture.RefArray) {
        self.encoder = encoder
        self.codingPathNode = codingPathNode
        self.reference = ref
    }

    // MARK: - UnkeyedEncodingContainer Methods

    public mutating func encodeNil() throws { reference.append(.null) }
    public mutating func encode(_ value: Bool) throws { reference.append(.bool(value)) }
    public mutating func encode(_ value: Int) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: Int8) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: Int16) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: Int32) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: Int64) throws { reference.append(encoder.wrap(value)) }
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public mutating func encode(_ value: Int128) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: UInt) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: UInt8) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: UInt16) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: UInt32) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: UInt64) throws { reference.append(encoder.wrap(value)) }
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public mutating func encode(_ value: UInt128) throws { reference.append(encoder.wrap(value)) }
    public mutating func encode(_ value: String) throws { reference.append(encoder.wrap(value)) }

    public mutating func encode(_ value: Float) throws {
        reference.append(try .number(from: value, encoder: encoder, _CodingKey(index: count)))
    }

    public mutating func encode(_ value: Double) throws {
        reference.append(try .number(from: value, encoder: encoder, _CodingKey(index: count)))
    }

    public mutating func encode<T: Encodable>(_ value: T) throws {
        let wrapped = try encoder.wrap(value, for: _CodingKey(index: count))
        reference.append(wrapped)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let index = count
        let nestedRef = reference.appendObject()
        let container = _JSONKeyedEncodingContainer<NestedKey>(referencing: encoder, codingPathNode: codingPathNode.appending(index: index), wrapping: nestedRef)
        return KeyedEncodingContainer(container)
    }

    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let index = count
        let nestedRef = reference.appendArray()
        return _JSONUnkeyedEncodingContainer(referencing: encoder, codingPathNode: codingPathNode.appending(index: index), wrapping: nestedRef)
    }

    public mutating func superEncoder() -> Encoder {
        return __JSONReferencingEncoder(referencing: encoder, at: reference.array.count, wrapping: reference)
    }
}

extension __JSONEncoder: SingleValueEncodingContainer {
    // MARK: - SingleValueEncodingContainer Methods

    private func assertCanEncodeNewValue() {
        precondition(
            singleValue == nil,
            mobs("Attempt to encode value through single value container when previously value already encoded."),
            file: "",
            line: 629
        )
    }

    public func encodeNil() throws {
        assertCanEncodeNewValue()
        singleValue = .null
    }

    public func encode(_ value: Bool) throws {
        assertCanEncodeNewValue()
        singleValue = .bool(value)
    }

    public func encode(_ value: Int) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: Int8) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: Int16) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: Int32) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: Int64) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func encode(_ value: Int128) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: UInt) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: UInt8) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: UInt16) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: UInt32) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: UInt64) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func encode(_ value: UInt128) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: String) throws {
        assertCanEncodeNewValue()
        singleValue = wrap(value)
    }

    public func encode(_ value: Float) throws {
        assertCanEncodeNewValue()
        let wrapped = try wrap(value)
        singleValue = wrapped
    }

    public func encode(_ value: Double) throws {
        assertCanEncodeNewValue()
        let wrapped = try wrap(value)
        singleValue = wrapped
    }

    public func encode<T: Encodable>(_ value: T) throws {
        assertCanEncodeNewValue()
        singleValue = try wrap(value)
    }
}

// MARK: - Concrete Value Representations

private extension __JSONEncoder {
    /// Returns the given value boxed in a container appropriate for pushing onto the container stack.
    @inline(__always) func wrap(_ value: Bool) -> JSONEncoderValue { .bool(value) }
    @inline(__always) func wrap(_ value: Int) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: Int8) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: Int16) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: Int32) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: Int64) -> JSONEncoderValue { .number(from: value) }
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    @inline(__always) func wrap(_ value: Int128) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: UInt) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: UInt8) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: UInt16) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: UInt32) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: UInt64) -> JSONEncoderValue { .number(from: value) }
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    @inline(__always) func wrap(_ value: UInt128) -> JSONEncoderValue { .number(from: value) }
    @inline(__always) func wrap(_ value: String) -> JSONEncoderValue { .string(value) }

    @inline(__always)
    func wrap(_ float: Float, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue {
        try .number(from: float, encoder: self, additionalKey)
    }

    @inline(__always)
    func wrap(_ double: Double, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue {
        try .number(from: double, encoder: self, additionalKey)
    }

    func wrap(_ date: Date, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue {
        switch options.dateEncodingStrategy {
        case .deferredToDate:
            var encoder = getEncoder(for: additionalKey)
            defer {
                returnEncoder(&encoder)
            }
            try date.encode(to: encoder)
            return encoder.takeValue().unsafelyUnwrapped

        case .secondsSince1970:
            return try .number(from: date.timeIntervalSince1970, with: .throw, encoder: self, additionalKey)

        case .millisecondsSince1970:
            return try .number(from: 1000.0 * date.timeIntervalSince1970, with: .throw, encoder: self, additionalKey)

        case .iso8601:
            return wrap(date.formatted(.iso8601))

        case let .formatted(formatter):
            return wrap(formatter.string(from: date))

        case let .custom(closure):
            var encoder = getEncoder(for: additionalKey)
            defer {
                returnEncoder(&encoder)
            }
            try closure(date, encoder)
            return encoder.takeValue() ?? .object([:])
        @unknown default:
            fatalError()
        }
    }

    func wrap(_ data: Data, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue {
        switch options.dataEncodingStrategy {
        case .deferredToData:
            var encoder = getEncoder(for: additionalKey)
            defer {
                returnEncoder(&encoder)
            }
            try data.encode(to: encoder)
            return encoder.takeValue().unsafelyUnwrapped

        case .base64:
            return wrap(data.base64EncodedString())

        case let .custom(closure):
            var encoder = getEncoder(for: additionalKey)
            defer {
                returnEncoder(&encoder)
            }
            try closure(data, encoder)
            return encoder.takeValue() ?? .object([:])
        @unknown default:
            fatalError()
        }
    }

    func wrap(_ dict: [String: Encodable], for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue? {
        var result = [String: JSONEncoderValue]()
        result.reserveCapacity(dict.count)

        let encoder = __JSONEncoder(options: options, ownerEncoder: self)
        for (key, value) in dict {
            encoder.codingKey = _CodingKey(stringValue: key)
            result[key] = try encoder.wrap(value)
        }

        return .object(result)
    }

    func wrap(_ value: Encodable, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue {
        return try wrapGeneric(value, for: additionalKey) ?? .object([:])
    }

    func wrapGeneric<T: Encodable>(_ value: T, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue? {

        if let date = value as? Date {
            // Respect Date encoding strategy
            return try wrap(date, for: additionalKey)
        } else if let data = value as? Data {
            // Respect Data encoding strategy
            return try wrap(data, for: additionalKey)
        } else if let url = value as? URL {
            // Encode URLs as single strings.
            return wrap(url.absoluteString)
        } else if let decimal = value as? Decimal {
            return .number(decimal.description)
        }

        return try _wrapGeneric({
            try value.encode(to: $0)
        }, for: additionalKey)
    }

    @available(macOS 12, *)
    func wrapGeneric<T: EncodableWithConfiguration>(_ value: T, configuration: T.EncodingConfiguration, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue? {
        try _wrapGeneric({
            try value.encode(to: $0, configuration: configuration)
        }, for: additionalKey)
    }

    @inline(__always)
    func _wrapGeneric(_ encode: (__JSONEncoder) throws -> Void, for additionalKey: (some CodingKey)? = _CodingKey?.none) throws -> JSONEncoderValue? {
        var encoder = getEncoder(for: additionalKey)
        defer {
            returnEncoder(&encoder)
        }
        try encode(encoder)
        return encoder.takeValue()
    }

    @inline(__always)
    func getEncoder(for additionalKey: CodingKey?) -> __JSONEncoder {
        if let additionalKey {
            if let takenEncoder = sharedSubEncoder {
                sharedSubEncoder = nil
                takenEncoder.codingKey = additionalKey
                takenEncoder.ownerEncoder = self
                return takenEncoder
            }
            return __JSONEncoder(options: options, ownerEncoder: self, codingKey: additionalKey)
        }

        return self
    }

    @inline(__always)
    func returnEncoder(_ encoder: inout __JSONEncoder) {
        if encoder !== self, sharedSubEncoder == nil, isKnownUniquelyReferenced(&encoder) {
            encoder.codingKey = nil
            encoder.ownerEncoder = nil // Prevent retain cycle.
            sharedSubEncoder = encoder
        }
    }
}

// MARK: - __JSONReferencingEncoder

/// __JSONReferencingEncoder is a special subclass of __JSONEncoder which has its own storage, but references the contents of a different encoder.
/// It's used in superEncoder(), which returns a new encoder for encoding a superclass -- the lifetime of the encoder should not escape the scope it's created in, but it doesn't necessarily know when it's done being used (to write to the original container).
// NOTE: older overlays called this class _JSONReferencingEncoder.
// The two must coexist without a conflicting ObjC class name, so it
// was renamed. The old name must not be used in the new runtime.
private class __JSONReferencingEncoder: __JSONEncoder {
    // MARK: Reference types.

    /// The type of container we're referencing.
    private enum Reference {
        /// Referencing a specific index in an array container.
        case array(JSONFuture.RefArray, Int)

        /// Referencing a specific key in a dictionary container.
        case dictionary(JSONFuture.RefObject, String)
    }

    // MARK: - Properties

    /// The encoder we're referencing.
    let encoder: __JSONEncoder

    /// The container reference itself.
    private let reference: Reference

    // MARK: - Initialization

    /// Initializes `self` by referencing the given array container in the given encoder.
    init(referencing encoder: __JSONEncoder, at index: Int, wrapping ref: JSONFuture.RefArray) {
        self.encoder = encoder
        self.reference = .array(ref, index)
        super.init(options: encoder.options, ownerEncoder: encoder, codingKey: _CodingKey(index: index))
    }

    /// Initializes `self` by referencing the given dictionary container in the given encoder.
    init(referencing encoder: __JSONEncoder, key: CodingKey, convertedKey: String, wrapping dictionary: JSONFuture.RefObject) {
        self.encoder = encoder
        self.reference = .dictionary(dictionary, convertedKey)
        super.init(options: encoder.options, ownerEncoder: encoder, codingKey: key)
    }

    // MARK: - Deinitialization

    // Finalizes `self` by writing the contents of our storage to the referenced encoder's storage.
    deinit {
        let value = self.takeValue() ?? JSONEncoderValue.object([:])

        switch self.reference {
        case let .array(arrayRef, index):
            arrayRef.insert(value, at: index)
        case let .dictionary(dictionaryRef, key):
            dictionaryRef.set(value, for: key)
        }
    }
}

extension JSONEncoderValue {
    static func number(from num: some(FixedWidthInteger & CustomStringConvertible)) -> JSONEncoderValue {
        return .number(num.description)
    }

    @inline(never)
    fileprivate static func cannotEncodeNumber<T: BinaryFloatingPoint>(_ float: T, encoder: __JSONEncoder, _ additionalKey: (some CodingKey)?) -> EncodingError {
        let path = encoder.codingPath + (additionalKey.map { [$0] } ?? [])
        return EncodingError.invalidValue(float, .init(
            codingPath: path,
            debugDescription: mobs("Unable to encode \(T.self).\(float) directly in JSON.")
        ))
    }

    @inline(never)
    fileprivate static func nonConformantNumber<T: BinaryFloatingPoint>(from float: T, with options: JSONEncoder.NonConformingFloatEncodingStrategy, encoder: __JSONEncoder, _ additionalKey: (some CodingKey)?) throws -> JSONEncoderValue {
        if case let .convertToString(posInfString, negInfString, nanString) = options {
            switch float {
            case T.infinity:
                return .string(posInfString)
            case -T.infinity:
                return .string(negInfString)
            default:
                // must be nan in this case
                return .string(nanString)
            }
        }
        throw cannotEncodeNumber(float, encoder: encoder, additionalKey)
    }

    @inline(__always)
    fileprivate static func number<T: BinaryFloatingPoint & CustomStringConvertible>(from float: T, with options: JSONEncoder.NonConformingFloatEncodingStrategy, encoder: __JSONEncoder, _ additionalKey: (some CodingKey)? = Optional<_CodingKey>.none) throws -> JSONEncoderValue {
        guard !float.isNaN, !float.isInfinite else {
            return try nonConformantNumber(from: float, with: options, encoder: encoder, additionalKey)
        }

        var string = float.description
        if string.hasSuffix(".0") {
            string.removeLast(2)
        }
        return .number(string)
    }

    @inline(__always)
    fileprivate static func number<T: BinaryFloatingPoint & CustomStringConvertible>(from float: T, encoder: __JSONEncoder, _ additionalKey: (some CodingKey)? = Optional<_CodingKey>.none) throws -> JSONEncoderValue {
        try .number(from: float, with: encoder.options.nonConformingFloatEncodingStrategy, encoder: encoder, additionalKey)
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension FastJSONEncoder: @unchecked Sendable {}
// swiftlint:enable all
