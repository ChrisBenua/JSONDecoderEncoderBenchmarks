import Foundation

public final class A5681: Codable, Sendable {
    public let a: Int
    public let b: A5682
    public let c: [A5683]
    public let d: [String: A5684]

    public init(a: Int,
        b: A5682,
        c: [A5683],
        d: [String: A5684]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5682.self, forKey: "b")
        self.c = try container.decode([A5683].self, forKey: "c")
        self.d = try container.decode([String: A5684].self, forKey: "d")
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

public final class A5682: Codable, Sendable {
    public let a: Int
    public let b: A5683
    public let c: [A5684]

    public init(a: Int,
        b: A5683,
        c: [A5684]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5683.self, forKey: "b")
        self.c = try container.decode([A5684].self, forKey: "c")
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

public final class A5683: Codable, Sendable {
    public let a: Int
    public let b: A5684

    public init(a: Int,
        b: A5684) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5684.self, forKey: "b")
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

public final class A5684: Codable, Sendable {
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

public final class A5685: Codable, Sendable {
    public let a: Int
    public let b: A5686
    public let c: [A5687]
    public let d: [String: A5688]

    public init(a: Int,
        b: A5686,
        c: [A5687],
        d: [String: A5688]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5686.self, forKey: "b")
        self.c = try container.decode([A5687].self, forKey: "c")
        self.d = try container.decode([String: A5688].self, forKey: "d")
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

public final class A5686: Codable, Sendable {
    public let a: Int
    public let b: A5687
    public let c: [A5688]

    public init(a: Int,
        b: A5687,
        c: [A5688]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5687.self, forKey: "b")
        self.c = try container.decode([A5688].self, forKey: "c")
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

public final class A5687: Codable, Sendable {
    public let a: Int
    public let b: A5688

    public init(a: Int,
        b: A5688) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5688.self, forKey: "b")
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

public final class A5688: Codable, Sendable {
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

public final class A5689: Codable, Sendable {
    public let a: Int
    public let b: A5690
    public let c: [A5691]
    public let d: [String: A5692]

    public init(a: Int,
        b: A5690,
        c: [A5691],
        d: [String: A5692]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5690.self, forKey: "b")
        self.c = try container.decode([A5691].self, forKey: "c")
        self.d = try container.decode([String: A5692].self, forKey: "d")
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

public final class A5690: Codable, Sendable {
    public let a: Int
    public let b: A5691
    public let c: [A5692]

    public init(a: Int,
        b: A5691,
        c: [A5692]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5691.self, forKey: "b")
        self.c = try container.decode([A5692].self, forKey: "c")
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

public final class A5691: Codable, Sendable {
    public let a: Int
    public let b: A5692

    public init(a: Int,
        b: A5692) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5692.self, forKey: "b")
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

public final class A5692: Codable, Sendable {
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

public final class A5693: Codable, Sendable {
    public let a: Int
    public let b: A5694
    public let c: [A5695]
    public let d: [String: A5696]

    public init(a: Int,
        b: A5694,
        c: [A5695],
        d: [String: A5696]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5694.self, forKey: "b")
        self.c = try container.decode([A5695].self, forKey: "c")
        self.d = try container.decode([String: A5696].self, forKey: "d")
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

public final class A5694: Codable, Sendable {
    public let a: Int
    public let b: A5695
    public let c: [A5696]

    public init(a: Int,
        b: A5695,
        c: [A5696]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5695.self, forKey: "b")
        self.c = try container.decode([A5696].self, forKey: "c")
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

public final class A5695: Codable, Sendable {
    public let a: Int
    public let b: A5696

    public init(a: Int,
        b: A5696) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5696.self, forKey: "b")
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

public final class A5696: Codable, Sendable {
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

public final class A5697: Codable, Sendable {
    public let a: Int
    public let b: A5698
    public let c: [A5699]
    public let d: [String: A5700]

    public init(a: Int,
        b: A5698,
        c: [A5699],
        d: [String: A5700]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5698.self, forKey: "b")
        self.c = try container.decode([A5699].self, forKey: "c")
        self.d = try container.decode([String: A5700].self, forKey: "d")
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

public final class A5698: Codable, Sendable {
    public let a: Int
    public let b: A5699
    public let c: [A5700]

    public init(a: Int,
        b: A5699,
        c: [A5700]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5699.self, forKey: "b")
        self.c = try container.decode([A5700].self, forKey: "c")
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

public final class A5699: Codable, Sendable {
    public let a: Int
    public let b: A5700

    public init(a: Int,
        b: A5700) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5700.self, forKey: "b")
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

public final class A5700: Codable, Sendable {
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

