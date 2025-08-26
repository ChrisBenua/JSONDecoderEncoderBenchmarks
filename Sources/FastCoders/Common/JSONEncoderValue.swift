// swiftlint:disable all
internal enum JSONEncoderValue: Equatable {
    case string(String)
    case number(String)
    case bool(Bool)
    case null

    case array([JSONEncoderValue])
    case object([String: JSONEncoderValue])

    case directArray([UInt8], lengths: [Int])
    case nonPrettyDirectArray([UInt8])
}

extension JSONEncoderValue {
    func convertedToObjectRef() -> JSONFuture.RefObject? {
        switch self {
        case let .object(dict):
            return .init(dict: .init(uniqueKeysWithValues: dict.map { ($0.key, .value($0.value)) }))
        default:
            return nil
        }
    }

    func convertedToArrayRef() -> JSONFuture.RefArray? {
        switch self {
        case let .array(array):
            return .init(array: array.map { .value($0) })
        default:
            return nil
        }
    }
}

// swiftlint:enable all
