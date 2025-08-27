import Foundation

public final class A5981: Codable, Sendable {
    public let a: Int
    public let b: A5982
    public let c: [A5983]
    public let d: [String: A5984]

    public init(a: Int,
        b: A5982,
        c: [A5983],
        d: [String: A5984]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5982.self, forKey: "b")
        self.c = try container.decode([A5983].self, forKey: "c")
        self.d = try container.decode([String: A5984].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5982: Codable, Sendable {
    public let a: Int
    public let b: A5983
    public let c: [A5984]

    public init(a: Int,
        b: A5983,
        c: [A5984]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5983.self, forKey: "b")
        self.c = try container.decode([A5984].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5983: Codable, Sendable {
    public let a: Int
    public let b: A5984

    public init(a: Int,
        b: A5984) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5984.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5984: Codable, Sendable {
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

public final class A5985: Codable, Sendable {
    public let a: Int
    public let b: A5986
    public let c: [A5987]
    public let d: [String: A5988]

    public init(a: Int,
        b: A5986,
        c: [A5987],
        d: [String: A5988]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5986.self, forKey: "b")
        self.c = try container.decode([A5987].self, forKey: "c")
        self.d = try container.decode([String: A5988].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5986: Codable, Sendable {
    public let a: Int
    public let b: A5987
    public let c: [A5988]

    public init(a: Int,
        b: A5987,
        c: [A5988]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5987.self, forKey: "b")
        self.c = try container.decode([A5988].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5987: Codable, Sendable {
    public let a: Int
    public let b: A5988

    public init(a: Int,
        b: A5988) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5988.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5988: Codable, Sendable {
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

public final class A5989: Codable, Sendable {
    public let a: Int
    public let b: A5990
    public let c: [A5991]
    public let d: [String: A5992]

    public init(a: Int,
        b: A5990,
        c: [A5991],
        d: [String: A5992]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5990.self, forKey: "b")
        self.c = try container.decode([A5991].self, forKey: "c")
        self.d = try container.decode([String: A5992].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5990: Codable, Sendable {
    public let a: Int
    public let b: A5991
    public let c: [A5992]

    public init(a: Int,
        b: A5991,
        c: [A5992]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5991.self, forKey: "b")
        self.c = try container.decode([A5992].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5991: Codable, Sendable {
    public let a: Int
    public let b: A5992

    public init(a: Int,
        b: A5992) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5992.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5992: Codable, Sendable {
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

public final class A5993: Codable, Sendable {
    public let a: Int
    public let b: A5994
    public let c: [A5995]
    public let d: [String: A5996]

    public init(a: Int,
        b: A5994,
        c: [A5995],
        d: [String: A5996]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5994.self, forKey: "b")
        self.c = try container.decode([A5995].self, forKey: "c")
        self.d = try container.decode([String: A5996].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5994: Codable, Sendable {
    public let a: Int
    public let b: A5995
    public let c: [A5996]

    public init(a: Int,
        b: A5995,
        c: [A5996]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5995.self, forKey: "b")
        self.c = try container.decode([A5996].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5995: Codable, Sendable {
    public let a: Int
    public let b: A5996

    public init(a: Int,
        b: A5996) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5996.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5996: Codable, Sendable {
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

public final class A5997: Codable, Sendable {
    public let a: Int
    public let b: A5998
    public let c: [A5999]
    public let d: [String: A6000]

    public init(a: Int,
        b: A5998,
        c: [A5999],
        d: [String: A6000]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5998.self, forKey: "b")
        self.c = try container.decode([A5999].self, forKey: "c")
        self.d = try container.decode([String: A6000].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5998: Codable, Sendable {
    public let a: Int
    public let b: A5999
    public let c: [A6000]

    public init(a: Int,
        b: A5999,
        c: [A6000]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5999.self, forKey: "b")
        self.c = try container.decode([A6000].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5999: Codable, Sendable {
    public let a: Int
    public let b: A6000

    public init(a: Int,
        b: A6000) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6000.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A6000: Codable, Sendable {
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

