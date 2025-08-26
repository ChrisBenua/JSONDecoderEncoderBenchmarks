import Foundation

public final class A5621: Codable, Sendable {
    public let a: Int
    public let b: A5622
    public let c: [A5623]
    public let d: [String: A5624]

    public init(a: Int,
        b: A5622,
        c: [A5623],
        d: [String: A5624]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5622.self, forKey: "b")
        self.c = try container.decode([A5623].self, forKey: "c")
        self.d = try container.decode([String: A5624].self, forKey: "d")
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

public final class A5622: Codable, Sendable {
    public let a: Int
    public let b: A5623
    public let c: [A5624]

    public init(a: Int,
        b: A5623,
        c: [A5624]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5623.self, forKey: "b")
        self.c = try container.decode([A5624].self, forKey: "c")
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

public final class A5623: Codable, Sendable {
    public let a: Int
    public let b: A5624

    public init(a: Int,
        b: A5624) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5624.self, forKey: "b")
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

public final class A5624: Codable, Sendable {
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

public final class A5625: Codable, Sendable {
    public let a: Int
    public let b: A5626
    public let c: [A5627]
    public let d: [String: A5628]

    public init(a: Int,
        b: A5626,
        c: [A5627],
        d: [String: A5628]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5626.self, forKey: "b")
        self.c = try container.decode([A5627].self, forKey: "c")
        self.d = try container.decode([String: A5628].self, forKey: "d")
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

public final class A5626: Codable, Sendable {
    public let a: Int
    public let b: A5627
    public let c: [A5628]

    public init(a: Int,
        b: A5627,
        c: [A5628]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5627.self, forKey: "b")
        self.c = try container.decode([A5628].self, forKey: "c")
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

public final class A5627: Codable, Sendable {
    public let a: Int
    public let b: A5628

    public init(a: Int,
        b: A5628) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5628.self, forKey: "b")
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

public final class A5628: Codable, Sendable {
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

public final class A5629: Codable, Sendable {
    public let a: Int
    public let b: A5630
    public let c: [A5631]
    public let d: [String: A5632]

    public init(a: Int,
        b: A5630,
        c: [A5631],
        d: [String: A5632]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5630.self, forKey: "b")
        self.c = try container.decode([A5631].self, forKey: "c")
        self.d = try container.decode([String: A5632].self, forKey: "d")
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

public final class A5630: Codable, Sendable {
    public let a: Int
    public let b: A5631
    public let c: [A5632]

    public init(a: Int,
        b: A5631,
        c: [A5632]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5631.self, forKey: "b")
        self.c = try container.decode([A5632].self, forKey: "c")
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

public final class A5631: Codable, Sendable {
    public let a: Int
    public let b: A5632

    public init(a: Int,
        b: A5632) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5632.self, forKey: "b")
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

public final class A5632: Codable, Sendable {
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

public final class A5633: Codable, Sendable {
    public let a: Int
    public let b: A5634
    public let c: [A5635]
    public let d: [String: A5636]

    public init(a: Int,
        b: A5634,
        c: [A5635],
        d: [String: A5636]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5634.self, forKey: "b")
        self.c = try container.decode([A5635].self, forKey: "c")
        self.d = try container.decode([String: A5636].self, forKey: "d")
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

public final class A5634: Codable, Sendable {
    public let a: Int
    public let b: A5635
    public let c: [A5636]

    public init(a: Int,
        b: A5635,
        c: [A5636]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5635.self, forKey: "b")
        self.c = try container.decode([A5636].self, forKey: "c")
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

public final class A5635: Codable, Sendable {
    public let a: Int
    public let b: A5636

    public init(a: Int,
        b: A5636) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5636.self, forKey: "b")
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

public final class A5636: Codable, Sendable {
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

public final class A5637: Codable, Sendable {
    public let a: Int
    public let b: A5638
    public let c: [A5639]
    public let d: [String: A5640]

    public init(a: Int,
        b: A5638,
        c: [A5639],
        d: [String: A5640]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5638.self, forKey: "b")
        self.c = try container.decode([A5639].self, forKey: "c")
        self.d = try container.decode([String: A5640].self, forKey: "d")
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

public final class A5638: Codable, Sendable {
    public let a: Int
    public let b: A5639
    public let c: [A5640]

    public init(a: Int,
        b: A5639,
        c: [A5640]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5639.self, forKey: "b")
        self.c = try container.decode([A5640].self, forKey: "c")
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

public final class A5639: Codable, Sendable {
    public let a: Int
    public let b: A5640

    public init(a: Int,
        b: A5640) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5640.self, forKey: "b")
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

public final class A5640: Codable, Sendable {
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

