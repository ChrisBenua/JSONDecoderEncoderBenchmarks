import Foundation

public final class A3641: Codable, Sendable {
    public let a: Int
    public let b: A3642
    public let c: [A3643]
    public let d: [String: A3644]

    public init(a: Int,
        b: A3642,
        c: [A3643],
        d: [String: A3644]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3642.self, forKey: "b")
        self.c = try container.decode([A3643].self, forKey: "c")
        self.d = try container.decode([String: A3644].self, forKey: "d")
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

public final class A3642: Codable, Sendable {
    public let a: Int
    public let b: A3643
    public let c: [A3644]

    public init(a: Int,
        b: A3643,
        c: [A3644]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3643.self, forKey: "b")
        self.c = try container.decode([A3644].self, forKey: "c")
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

public final class A3643: Codable, Sendable {
    public let a: Int
    public let b: A3644

    public init(a: Int,
        b: A3644) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3644.self, forKey: "b")
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

public final class A3644: Codable, Sendable {
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

public final class A3645: Codable, Sendable {
    public let a: Int
    public let b: A3646
    public let c: [A3647]
    public let d: [String: A3648]

    public init(a: Int,
        b: A3646,
        c: [A3647],
        d: [String: A3648]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3646.self, forKey: "b")
        self.c = try container.decode([A3647].self, forKey: "c")
        self.d = try container.decode([String: A3648].self, forKey: "d")
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

public final class A3646: Codable, Sendable {
    public let a: Int
    public let b: A3647
    public let c: [A3648]

    public init(a: Int,
        b: A3647,
        c: [A3648]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3647.self, forKey: "b")
        self.c = try container.decode([A3648].self, forKey: "c")
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

public final class A3647: Codable, Sendable {
    public let a: Int
    public let b: A3648

    public init(a: Int,
        b: A3648) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3648.self, forKey: "b")
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

public final class A3648: Codable, Sendable {
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

public final class A3649: Codable, Sendable {
    public let a: Int
    public let b: A3650
    public let c: [A3651]
    public let d: [String: A3652]

    public init(a: Int,
        b: A3650,
        c: [A3651],
        d: [String: A3652]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3650.self, forKey: "b")
        self.c = try container.decode([A3651].self, forKey: "c")
        self.d = try container.decode([String: A3652].self, forKey: "d")
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

public final class A3650: Codable, Sendable {
    public let a: Int
    public let b: A3651
    public let c: [A3652]

    public init(a: Int,
        b: A3651,
        c: [A3652]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3651.self, forKey: "b")
        self.c = try container.decode([A3652].self, forKey: "c")
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

public final class A3651: Codable, Sendable {
    public let a: Int
    public let b: A3652

    public init(a: Int,
        b: A3652) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3652.self, forKey: "b")
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

public final class A3652: Codable, Sendable {
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

public final class A3653: Codable, Sendable {
    public let a: Int
    public let b: A3654
    public let c: [A3655]
    public let d: [String: A3656]

    public init(a: Int,
        b: A3654,
        c: [A3655],
        d: [String: A3656]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3654.self, forKey: "b")
        self.c = try container.decode([A3655].self, forKey: "c")
        self.d = try container.decode([String: A3656].self, forKey: "d")
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

public final class A3654: Codable, Sendable {
    public let a: Int
    public let b: A3655
    public let c: [A3656]

    public init(a: Int,
        b: A3655,
        c: [A3656]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3655.self, forKey: "b")
        self.c = try container.decode([A3656].self, forKey: "c")
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

public final class A3655: Codable, Sendable {
    public let a: Int
    public let b: A3656

    public init(a: Int,
        b: A3656) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3656.self, forKey: "b")
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

public final class A3656: Codable, Sendable {
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

public final class A3657: Codable, Sendable {
    public let a: Int
    public let b: A3658
    public let c: [A3659]
    public let d: [String: A3660]

    public init(a: Int,
        b: A3658,
        c: [A3659],
        d: [String: A3660]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3658.self, forKey: "b")
        self.c = try container.decode([A3659].self, forKey: "c")
        self.d = try container.decode([String: A3660].self, forKey: "d")
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

public final class A3658: Codable, Sendable {
    public let a: Int
    public let b: A3659
    public let c: [A3660]

    public init(a: Int,
        b: A3659,
        c: [A3660]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3659.self, forKey: "b")
        self.c = try container.decode([A3660].self, forKey: "c")
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

public final class A3659: Codable, Sendable {
    public let a: Int
    public let b: A3660

    public init(a: Int,
        b: A3660) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A3660.self, forKey: "b")
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

public final class A3660: Codable, Sendable {
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

