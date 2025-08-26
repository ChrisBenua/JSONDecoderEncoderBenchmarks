// swiftlint:disable all
internal enum _CodingPathNode: Sendable {
    case root
    indirect case node(CodingKey, _CodingPathNode, depth: Int)
    indirect case indexNode(Int, _CodingPathNode, depth: Int)

    var path: [CodingKey] {
        switch self {
        case .root:
            return []
        case let .node(key, parent, _):
            return parent.path + [key]
        case let .indexNode(index, parent, _):
            return parent.path + [_CodingKey(index: index)]
        }
    }

    @inline(__always)
    var depth: Int {
        switch self {
        case .root: return 0
        case let .node(_, _, depth), let .indexNode(_, _, depth): return depth
        }
    }

    @inline(__always)
    func appending(_ key: __owned(some CodingKey)?) -> _CodingPathNode {
        if let key {
            return .node(key, self, depth: depth + 1)
        } else {
            return self
        }
    }

    @inline(__always)
    func path(byAppending key: __owned(some CodingKey)?) -> [CodingKey] {
        if let key {
            return path + [key]
        }
        return path
    }

    // Specializations for indexes, commonly used by unkeyed containers.
    @inline(__always)
    func appending(index: __owned Int) -> _CodingPathNode {
        .indexNode(index, self, depth: depth + 1)
    }

    func path(byAppendingIndex index: __owned Int) -> [CodingKey] {
        path + [_CodingKey(index: index)]
    }
}

// swiftlint:enable all
