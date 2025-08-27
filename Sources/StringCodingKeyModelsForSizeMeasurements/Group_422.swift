import Foundation

public final class A8441: Codable, Sendable {
    public let a: Int
    public let b: A8442
    public let c: [A8443]
    public let d: [String: A8444]

    public init(a: Int,
        b: A8442,
        c: [A8443],
        d: [String: A8444]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8442.self, forKey: "b")
        self.c = try container.decode([A8443].self, forKey: "c")
        self.d = try container.decode([String: A8444].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A8442: Codable, Sendable {
    public let a: Int
    public let b: A8443
    public let c: [A8444]

    public init(a: Int,
        b: A8443,
        c: [A8444]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8443.self, forKey: "b")
        self.c = try container.decode([A8444].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A8443: Codable, Sendable {
    public let a: Int
    public let b: A8444

    public init(a: Int,
        b: A8444) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8444.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A8444: Codable, Sendable {
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
}

public final class A8445: Codable, Sendable {
    public let a: Int
    public let b: A8446
    public let c: [A8447]
    public let d: [String: A8448]

    public init(a: Int,
        b: A8446,
        c: [A8447],
        d: [String: A8448]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8446.self, forKey: "b")
        self.c = try container.decode([A8447].self, forKey: "c")
        self.d = try container.decode([String: A8448].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A8446: Codable, Sendable {
    public let a: Int
    public let b: A8447
    public let c: [A8448]

    public init(a: Int,
        b: A8447,
        c: [A8448]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8447.self, forKey: "b")
        self.c = try container.decode([A8448].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A8447: Codable, Sendable {
    public let a: Int
    public let b: A8448

    public init(a: Int,
        b: A8448) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8448.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A8448: Codable, Sendable {
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
}

public final class A8449: Codable, Sendable {
    public let a: Int
    public let b: A8450
    public let c: [A8451]
    public let d: [String: A8452]

    public init(a: Int,
        b: A8450,
        c: [A8451],
        d: [String: A8452]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8450.self, forKey: "b")
        self.c = try container.decode([A8451].self, forKey: "c")
        self.d = try container.decode([String: A8452].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A8450: Codable, Sendable {
    public let a: Int
    public let b: A8451
    public let c: [A8452]

    public init(a: Int,
        b: A8451,
        c: [A8452]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8451.self, forKey: "b")
        self.c = try container.decode([A8452].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A8451: Codable, Sendable {
    public let a: Int
    public let b: A8452

    public init(a: Int,
        b: A8452) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8452.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A8452: Codable, Sendable {
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
}

public final class A8453: Codable, Sendable {
    public let a: Int
    public let b: A8454
    public let c: [A8455]
    public let d: [String: A8456]

    public init(a: Int,
        b: A8454,
        c: [A8455],
        d: [String: A8456]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8454.self, forKey: "b")
        self.c = try container.decode([A8455].self, forKey: "c")
        self.d = try container.decode([String: A8456].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A8454: Codable, Sendable {
    public let a: Int
    public let b: A8455
    public let c: [A8456]

    public init(a: Int,
        b: A8455,
        c: [A8456]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8455.self, forKey: "b")
        self.c = try container.decode([A8456].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A8455: Codable, Sendable {
    public let a: Int
    public let b: A8456

    public init(a: Int,
        b: A8456) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8456.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A8456: Codable, Sendable {
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
}

public final class A8457: Codable, Sendable {
    public let a: Int
    public let b: A8458
    public let c: [A8459]
    public let d: [String: A8460]

    public init(a: Int,
        b: A8458,
        c: [A8459],
        d: [String: A8460]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8458.self, forKey: "b")
        self.c = try container.decode([A8459].self, forKey: "c")
        self.d = try container.decode([String: A8460].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A8458: Codable, Sendable {
    public let a: Int
    public let b: A8459
    public let c: [A8460]

    public init(a: Int,
        b: A8459,
        c: [A8460]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8459.self, forKey: "b")
        self.c = try container.decode([A8460].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A8459: Codable, Sendable {
    public let a: Int
    public let b: A8460

    public init(a: Int,
        b: A8460) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A8460.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A8460: Codable, Sendable {
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
}

