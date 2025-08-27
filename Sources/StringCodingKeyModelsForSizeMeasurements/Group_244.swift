import Foundation

public final class A4881: Codable, Sendable {
    public let a: Int
    public let b: A4882
    public let c: [A4883]
    public let d: [String: A4884]

    public init(a: Int,
        b: A4882,
        c: [A4883],
        d: [String: A4884]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4882.self, forKey: "b")
        self.c = try container.decode([A4883].self, forKey: "c")
        self.d = try container.decode([String: A4884].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4882: Codable, Sendable {
    public let a: Int
    public let b: A4883
    public let c: [A4884]

    public init(a: Int,
        b: A4883,
        c: [A4884]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4883.self, forKey: "b")
        self.c = try container.decode([A4884].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4883: Codable, Sendable {
    public let a: Int
    public let b: A4884

    public init(a: Int,
        b: A4884) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4884.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4884: Codable, Sendable {
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

public final class A4885: Codable, Sendable {
    public let a: Int
    public let b: A4886
    public let c: [A4887]
    public let d: [String: A4888]

    public init(a: Int,
        b: A4886,
        c: [A4887],
        d: [String: A4888]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4886.self, forKey: "b")
        self.c = try container.decode([A4887].self, forKey: "c")
        self.d = try container.decode([String: A4888].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4886: Codable, Sendable {
    public let a: Int
    public let b: A4887
    public let c: [A4888]

    public init(a: Int,
        b: A4887,
        c: [A4888]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4887.self, forKey: "b")
        self.c = try container.decode([A4888].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4887: Codable, Sendable {
    public let a: Int
    public let b: A4888

    public init(a: Int,
        b: A4888) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4888.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4888: Codable, Sendable {
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

public final class A4889: Codable, Sendable {
    public let a: Int
    public let b: A4890
    public let c: [A4891]
    public let d: [String: A4892]

    public init(a: Int,
        b: A4890,
        c: [A4891],
        d: [String: A4892]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4890.self, forKey: "b")
        self.c = try container.decode([A4891].self, forKey: "c")
        self.d = try container.decode([String: A4892].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4890: Codable, Sendable {
    public let a: Int
    public let b: A4891
    public let c: [A4892]

    public init(a: Int,
        b: A4891,
        c: [A4892]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4891.self, forKey: "b")
        self.c = try container.decode([A4892].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4891: Codable, Sendable {
    public let a: Int
    public let b: A4892

    public init(a: Int,
        b: A4892) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4892.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4892: Codable, Sendable {
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

public final class A4893: Codable, Sendable {
    public let a: Int
    public let b: A4894
    public let c: [A4895]
    public let d: [String: A4896]

    public init(a: Int,
        b: A4894,
        c: [A4895],
        d: [String: A4896]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4894.self, forKey: "b")
        self.c = try container.decode([A4895].self, forKey: "c")
        self.d = try container.decode([String: A4896].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4894: Codable, Sendable {
    public let a: Int
    public let b: A4895
    public let c: [A4896]

    public init(a: Int,
        b: A4895,
        c: [A4896]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4895.self, forKey: "b")
        self.c = try container.decode([A4896].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4895: Codable, Sendable {
    public let a: Int
    public let b: A4896

    public init(a: Int,
        b: A4896) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4896.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4896: Codable, Sendable {
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

public final class A4897: Codable, Sendable {
    public let a: Int
    public let b: A4898
    public let c: [A4899]
    public let d: [String: A4900]

    public init(a: Int,
        b: A4898,
        c: [A4899],
        d: [String: A4900]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4898.self, forKey: "b")
        self.c = try container.decode([A4899].self, forKey: "c")
        self.d = try container.decode([String: A4900].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4898: Codable, Sendable {
    public let a: Int
    public let b: A4899
    public let c: [A4900]

    public init(a: Int,
        b: A4899,
        c: [A4900]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4899.self, forKey: "b")
        self.c = try container.decode([A4900].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4899: Codable, Sendable {
    public let a: Int
    public let b: A4900

    public init(a: Int,
        b: A4900) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4900.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4900: Codable, Sendable {
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

