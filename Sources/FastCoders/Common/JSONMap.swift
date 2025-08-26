// swiftlint:disable all



internal class JSONMap {
    enum TypeDescriptor: Int {
        case string // [marker, count, sourceByteOffset]
        case number // [marker, count, sourceByteOffset]
        case null // [marker]
        case `true` // [marker]
        case `false` // [marker]

        case object // [marker, nextSiblingOffset, count, <keys and values>, .collectionEnd]
        case array // [marker, nextSiblingOffset, count, <values>, .collectionEnd]
        case collectionEnd

        case simpleString // [marker, count, sourceByteOffset]
        case numberContainingExponent // [marker, count, sourceByteOffset]

        @inline(__always)
        var mapMarker: Int {
            rawValue
        }
    }

    struct Region {
        let startOffset: Int
        let count: Int
    }

    enum Value {
        case string(Region, isSimple: Bool)
        case number(Region, containsExponent: Bool)
        case bool(Bool)
        case null

        case object(Region)
        case array(Region)
    }

    let mapBuffer: [Int]
    var dataLock: LockedState<(buffer: BufferView<UInt8>, allocation: UnsafeRawPointer?)>

    init(mapBuffer: [Int], dataBuffer: BufferView<UInt8>) {
        self.mapBuffer = mapBuffer
        self.dataLock = .init(initialState: (buffer: dataBuffer, allocation: nil))
    }

    func copyInBuffer() {
        dataLock.withLock { state in
            guard state.allocation == nil else {
                return
            }

            // Allocate an additional byte to ensure we have a trailing NUL byte which is important for cases like a floating point number fragment.
            let (p, c) = state.buffer.withUnsafeRawPointer {
                pointer, capacity -> (UnsafeRawPointer, Int) in
                let raw = UnsafeMutableRawPointer.allocate(byteCount: capacity + 1, alignment: 1)
                raw.copyMemory(from: pointer, byteCount: capacity)
                raw.storeBytes(of: UInt8.zero, toByteOffset: capacity, as: UInt8.self)
                return (.init(raw), capacity + 1)
            }

            state = (buffer: .init(unsafeBaseAddress: p, count: c), allocation: p)
        }
    }

    @inline(__always)
    func withBuffer<T>(
        for region: Region, perform closure: @Sendable(_ jsonBytes: BufferView<UInt8>, _ fullSource: BufferView<UInt8>) throws -> T
    ) rethrows -> T {
        try dataLock.withLock {
            return try closure($0.buffer[region], $0.buffer)
        }
    }

    deinit {
        dataLock.withLock {
            if let allocatedPointer = $0.allocation {
                precondition($0.buffer.startIndex == BufferViewIndex(rawValue: allocatedPointer))
                allocatedPointer.deallocate()
            }
        }
    }

    func loadValue(at mapOffset: Int) -> Value? {
        let marker = mapBuffer[mapOffset]
        let type = JSONMap.TypeDescriptor(rawValue: marker)
        switch type {
        case .string, .simpleString:
            let length = mapBuffer[mapOffset + 1]
            let dataOffset = mapBuffer[mapOffset + 2]
            return .string(.init(startOffset: dataOffset, count: length), isSimple: type == .simpleString)
        case .number, .numberContainingExponent:
            let length = mapBuffer[mapOffset + 1]
            let dataOffset = mapBuffer[mapOffset + 2]
            return .number(.init(startOffset: dataOffset, count: length), containsExponent: type == .numberContainingExponent)
        case .object:
            // Skip the offset to the next sibling value.
            let count = mapBuffer[mapOffset + 2]
            return .object(.init(startOffset: mapOffset + 3, count: count))
        case .array:
            // Skip the offset to the next sibling value.
            let count = mapBuffer[mapOffset + 2]
            return .array(.init(startOffset: mapOffset + 3, count: count))
        case .null:
            return .null
        case .true:
            return .bool(true)
        case .false:
            return .bool(false)
        case .collectionEnd:
            return nil
        default:
            fatalError(
                mobs("Invalid JSON value type code in mapping: \(marker))"),
                file: "",
                line: 115
            )
        }
    }

    func offset(after previousValueOffset: Int) -> Int {
        let marker = mapBuffer[previousValueOffset]
        let type = JSONMap.TypeDescriptor(rawValue: marker)
        switch type {
        case .string, .simpleString, .number, .numberContainingExponent:
            return previousValueOffset + 3 // Skip marker, length, and data offset
        case .null, .true, .false:
            return previousValueOffset + 1 // Skip only the marker.
        case .object, .array:
            // The collection records the offset to the next sibling.
            return mapBuffer[previousValueOffset + 1]
        case .collectionEnd:
            fatalError(
                mobs("Attempt to find next object past the end of collection at offset \(previousValueOffset))"),
                file: "",
                line: 135
            )
        default:
            fatalError(
                mobs("Invalid JSON value type code in mapping: \(marker))"),
                file: "",
                line: 141
            )
        }
    }

    struct ArrayIterator {
        var currentOffset: Int
        let map: JSONMap

        mutating func next() -> JSONMap.Value? {
            guard let next = peek() else {
                return nil
            }
            advance()
            return next
        }

        func peek() -> JSONMap.Value? {
            guard let next = map.loadValue(at: currentOffset) else {
                return nil
            }
            return next
        }

        mutating func advance() {
            currentOffset = map.offset(after: currentOffset)
        }
    }

    func makeArrayIterator(from offset: Int) -> ArrayIterator {
        return .init(currentOffset: offset, map: self)
    }

    struct ObjectIterator {
        var currentOffset: Int
        let map: JSONMap

        mutating func next() -> (key: JSONMap.Value, value: JSONMap.Value)? {
            let keyOffset = currentOffset
            guard let key = map.loadValue(at: currentOffset) else {
                return nil
            }
            let valueOffset = map.offset(after: keyOffset)
            guard let value = map.loadValue(at: valueOffset) else {
                preconditionFailure(
                    mobs("JSONMap object constructed incorrectly. No value found for key"),
                    file: "",
                    line: 188
                )
            }
            currentOffset = map.offset(after: valueOffset)
            return (key, value)
        }
    }

    func makeObjectIterator(from offset: Int) -> ObjectIterator {
        return .init(currentOffset: offset, map: self)
    }
}

extension JSONMap.Value {
    var debugDataTypeDescription: String {
        switch self {
        case .string: return mobs("a string")
        case .number: return mobs("number")
        case .bool: return mobs("bool")
        case .null: return mobs("null")
        case .object: return mobs("a dictionary")
        case .array: return mobs("an array")
        }
    }
}

// swiftlint:enable all
