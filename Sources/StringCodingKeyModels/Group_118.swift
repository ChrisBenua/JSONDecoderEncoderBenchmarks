import Foundation

public final class A2361: Codable, Sendable {
    public let a: Int
    public let b: A2362
    public let c: [A2363]
    public let d: [String: A2364]

    public init(a: Int,
        b: A2362,
        c: [A2363],
        d: [String: A2364]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2362.self, forKey: "b")
        self.c = try container.decode([A2363].self, forKey: "c")
        self.d = try container.decode([String: A2364].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
    }
}

public final class A2362: Codable, Sendable {
    public let a: Int
    public let b: A2363
    public let c: [A2364]

    public init(a: Int,
        b: A2363,
        c: [A2364]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2363.self, forKey: "b")
        self.c = try container.decode([A2364].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}

public final class A2363: Codable, Sendable {
    public let a: Int
    public let b: A2364

    public init(a: Int,
        b: A2364) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2364.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
    }
}

public final class A2364: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
    }
    public enum CodingKeys: CodingKey {
        case a
    }
}

public final class A2365: Codable, Sendable {
    public let a: Int
    public let b: A2366
    public let c: [A2367]
    public let d: [String: A2368]

    public init(a: Int,
        b: A2366,
        c: [A2367],
        d: [String: A2368]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2366.self, forKey: "b")
        self.c = try container.decode([A2367].self, forKey: "c")
        self.d = try container.decode([String: A2368].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
    }
}

public final class A2366: Codable, Sendable {
    public let a: Int
    public let b: A2367
    public let c: [A2368]

    public init(a: Int,
        b: A2367,
        c: [A2368]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2367.self, forKey: "b")
        self.c = try container.decode([A2368].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}

public final class A2367: Codable, Sendable {
    public let a: Int
    public let b: A2368

    public init(a: Int,
        b: A2368) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2368.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
    }
}

public final class A2368: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
    }
    public enum CodingKeys: CodingKey {
        case a
    }
}

public final class A2369: Codable, Sendable {
    public let a: Int
    public let b: A2370
    public let c: [A2371]
    public let d: [String: A2372]

    public init(a: Int,
        b: A2370,
        c: [A2371],
        d: [String: A2372]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2370.self, forKey: "b")
        self.c = try container.decode([A2371].self, forKey: "c")
        self.d = try container.decode([String: A2372].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
    }
}

public final class A2370: Codable, Sendable {
    public let a: Int
    public let b: A2371
    public let c: [A2372]

    public init(a: Int,
        b: A2371,
        c: [A2372]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2371.self, forKey: "b")
        self.c = try container.decode([A2372].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}

public final class A2371: Codable, Sendable {
    public let a: Int
    public let b: A2372

    public init(a: Int,
        b: A2372) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2372.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
    }
}

public final class A2372: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
    }
    public enum CodingKeys: CodingKey {
        case a
    }
}

public final class A2373: Codable, Sendable {
    public let a: Int
    public let b: A2374
    public let c: [A2375]
    public let d: [String: A2376]

    public init(a: Int,
        b: A2374,
        c: [A2375],
        d: [String: A2376]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2374.self, forKey: "b")
        self.c = try container.decode([A2375].self, forKey: "c")
        self.d = try container.decode([String: A2376].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
    }
}

public final class A2374: Codable, Sendable {
    public let a: Int
    public let b: A2375
    public let c: [A2376]

    public init(a: Int,
        b: A2375,
        c: [A2376]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2375.self, forKey: "b")
        self.c = try container.decode([A2376].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}

public final class A2375: Codable, Sendable {
    public let a: Int
    public let b: A2376

    public init(a: Int,
        b: A2376) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2376.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
    }
}

public final class A2376: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
    }
    public enum CodingKeys: CodingKey {
        case a
    }
}

public final class A2377: Codable, Sendable {
    public let a: Int
    public let b: A2378
    public let c: [A2379]
    public let d: [String: A2380]

    public init(a: Int,
        b: A2378,
        c: [A2379],
        d: [String: A2380]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2378.self, forKey: "b")
        self.c = try container.decode([A2379].self, forKey: "c")
        self.d = try container.decode([String: A2380].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
    }
}

public final class A2378: Codable, Sendable {
    public let a: Int
    public let b: A2379
    public let c: [A2380]

    public init(a: Int,
        b: A2379,
        c: [A2380]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2379.self, forKey: "b")
        self.c = try container.decode([A2380].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}

public final class A2379: Codable, Sendable {
    public let a: Int
    public let b: A2380

    public init(a: Int,
        b: A2380) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A2380.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
    public enum CodingKeys: CodingKey {
        case a
        case b
    }
}

public final class A2380: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
    }
    public enum CodingKeys: CodingKey {
        case a
    }
}

