import Foundation

public final class A5421: Codable, Sendable {
    public let a: Int
    public let b: A5422
    public let c: [A5423]
    public let d: [String: A5424]

    public init(a: Int,
        b: A5422,
        c: [A5423],
        d: [String: A5424]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5422.self, forKey: "b")
        self.c = try container.decode([A5423].self, forKey: "c")
        self.d = try container.decode([String: A5424].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5422: Codable, Sendable {
    public let a: Int
    public let b: A5423
    public let c: [A5424]

    public init(a: Int,
        b: A5423,
        c: [A5424]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5423.self, forKey: "b")
        self.c = try container.decode([A5424].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5423: Codable, Sendable {
    public let a: Int
    public let b: A5424

    public init(a: Int,
        b: A5424) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5424.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5424: Codable, Sendable {
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

public final class A5425: Codable, Sendable {
    public let a: Int
    public let b: A5426
    public let c: [A5427]
    public let d: [String: A5428]

    public init(a: Int,
        b: A5426,
        c: [A5427],
        d: [String: A5428]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5426.self, forKey: "b")
        self.c = try container.decode([A5427].self, forKey: "c")
        self.d = try container.decode([String: A5428].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5426: Codable, Sendable {
    public let a: Int
    public let b: A5427
    public let c: [A5428]

    public init(a: Int,
        b: A5427,
        c: [A5428]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5427.self, forKey: "b")
        self.c = try container.decode([A5428].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5427: Codable, Sendable {
    public let a: Int
    public let b: A5428

    public init(a: Int,
        b: A5428) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5428.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5428: Codable, Sendable {
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

public final class A5429: Codable, Sendable {
    public let a: Int
    public let b: A5430
    public let c: [A5431]
    public let d: [String: A5432]

    public init(a: Int,
        b: A5430,
        c: [A5431],
        d: [String: A5432]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5430.self, forKey: "b")
        self.c = try container.decode([A5431].self, forKey: "c")
        self.d = try container.decode([String: A5432].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5430: Codable, Sendable {
    public let a: Int
    public let b: A5431
    public let c: [A5432]

    public init(a: Int,
        b: A5431,
        c: [A5432]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5431.self, forKey: "b")
        self.c = try container.decode([A5432].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5431: Codable, Sendable {
    public let a: Int
    public let b: A5432

    public init(a: Int,
        b: A5432) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5432.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5432: Codable, Sendable {
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

public final class A5433: Codable, Sendable {
    public let a: Int
    public let b: A5434
    public let c: [A5435]
    public let d: [String: A5436]

    public init(a: Int,
        b: A5434,
        c: [A5435],
        d: [String: A5436]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5434.self, forKey: "b")
        self.c = try container.decode([A5435].self, forKey: "c")
        self.d = try container.decode([String: A5436].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5434: Codable, Sendable {
    public let a: Int
    public let b: A5435
    public let c: [A5436]

    public init(a: Int,
        b: A5435,
        c: [A5436]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5435.self, forKey: "b")
        self.c = try container.decode([A5436].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5435: Codable, Sendable {
    public let a: Int
    public let b: A5436

    public init(a: Int,
        b: A5436) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5436.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5436: Codable, Sendable {
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

public final class A5437: Codable, Sendable {
    public let a: Int
    public let b: A5438
    public let c: [A5439]
    public let d: [String: A5440]

    public init(a: Int,
        b: A5438,
        c: [A5439],
        d: [String: A5440]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5438.self, forKey: "b")
        self.c = try container.decode([A5439].self, forKey: "c")
        self.d = try container.decode([String: A5440].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A5438: Codable, Sendable {
    public let a: Int
    public let b: A5439
    public let c: [A5440]

    public init(a: Int,
        b: A5439,
        c: [A5440]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5439.self, forKey: "b")
        self.c = try container.decode([A5440].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A5439: Codable, Sendable {
    public let a: Int
    public let b: A5440

    public init(a: Int,
        b: A5440) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A5440.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A5440: Codable, Sendable {
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

