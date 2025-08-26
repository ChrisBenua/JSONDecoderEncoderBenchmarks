// swiftlint:disable all



enum JSONFuture {
    case value(JSONEncoderValue)
    case nestedArray(RefArray)
    case nestedObject(RefObject)

    var object: RefObject? {
        switch self {
        case let .nestedObject(obj): obj
        default: nil
        }
    }

    var array: RefArray? {
        switch self {
        case let .nestedArray(array): array
        default: nil
        }
    }

    class RefArray {
        private(set) var array: [JSONFuture] = []

        init() {
            array.reserveCapacity(10)
        }

        init(array: [JSONFuture]) {
            self.array = array
        }

        @inline(__always) func append(_ element: JSONEncoderValue) {
            array.append(.value(element))
        }

        @inline(__always) func insert(_ element: JSONEncoderValue, at index: Int) {
            array.insert(.value(element), at: index)
        }

        @inline(__always) func appendArray() -> RefArray {
            let array = RefArray()
            self.array.append(.nestedArray(array))
            return array
        }

        @inline(__always) func appendObject() -> RefObject {
            let object = RefObject()
            array.append(.nestedObject(object))
            return object
        }

        var values: [JSONEncoderValue] {
            array.map { (future) -> JSONEncoderValue in
                switch future {
                case let .value(value):
                    return value
                case let .nestedArray(array):
                    return .array(array.values)
                case let .nestedObject(object):
                    return .object(object.values)
                }
            }
        }
    }

    class RefObject {
        var dict: [String: JSONFuture] = [:]

        init() {
            dict.reserveCapacity(4)
        }

        init(dict: [String: JSONFuture]) {
            self.dict = dict
        }

        @inline(__always) func set(_ value: JSONEncoderValue, for key: String) {
            dict[key] = .value(value)
        }

        @inline(__always) func setArray(for key: String) -> RefArray {
            switch dict[key] {
            case .nestedObject:
                preconditionFailure(
                    mobs("For key \"\(key)\" a keyed container has already been created."),
                    file: "",
                    line: 87
                )
            case let .nestedArray(array):
                return array
            case .none, .value:
                let array = RefArray()
                dict[key] = .nestedArray(array)
                return array
            }
        }

        @inline(__always) func setObject(for key: String) -> RefObject {
            switch dict[key] {
            case let .nestedObject(object):
                return object
            case .nestedArray:
                preconditionFailure(
                    mobs("For key \"\(key)\" a unkeyed container has already been created."),
                    file: "",
                    line: 106
                )
            case .none, .value:
                let object = RefObject()
                dict[key] = .nestedObject(object)
                return object
            }
        }

        var values: [String: JSONEncoderValue] {
            dict.mapValues { (future) -> JSONEncoderValue in
                switch future {
                case let .value(value):
                    return value
                case let .nestedArray(array):
                    return .array(array.values)
                case let .nestedObject(object):
                    return .object(object.values)
                }
            }
        }
    }
}

// swiftlint:enable all
