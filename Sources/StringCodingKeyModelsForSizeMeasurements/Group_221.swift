import Foundation

public final class A4421: Codable, Sendable {
    public let a: Int
    public let b: A4422
    public let c: [A4423]
    public let d: [String: A4424]

    public init(a: Int,
        b: A4422,
        c: [A4423],
        d: [String: A4424]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4422.self, forKey: "b")
        self.c = try container.decode([A4423].self, forKey: "c")
        self.d = try container.decode([String: A4424].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4422: Codable, Sendable {
    public let a: Int
    public let b: A4423
    public let c: [A4424]

    public init(a: Int,
        b: A4423,
        c: [A4424]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4423.self, forKey: "b")
        self.c = try container.decode([A4424].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4423: Codable, Sendable {
    public let a: Int
    public let b: A4424

    public init(a: Int,
        b: A4424) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4424.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4424: Codable, Sendable {
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

public final class A4425: Codable, Sendable {
    public let a: Int
    public let b: A4426
    public let c: [A4427]
    public let d: [String: A4428]

    public init(a: Int,
        b: A4426,
        c: [A4427],
        d: [String: A4428]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4426.self, forKey: "b")
        self.c = try container.decode([A4427].self, forKey: "c")
        self.d = try container.decode([String: A4428].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4426: Codable, Sendable {
    public let a: Int
    public let b: A4427
    public let c: [A4428]

    public init(a: Int,
        b: A4427,
        c: [A4428]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4427.self, forKey: "b")
        self.c = try container.decode([A4428].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4427: Codable, Sendable {
    public let a: Int
    public let b: A4428

    public init(a: Int,
        b: A4428) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4428.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4428: Codable, Sendable {
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

public final class A4429: Codable, Sendable {
    public let a: Int
    public let b: A4430
    public let c: [A4431]
    public let d: [String: A4432]

    public init(a: Int,
        b: A4430,
        c: [A4431],
        d: [String: A4432]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4430.self, forKey: "b")
        self.c = try container.decode([A4431].self, forKey: "c")
        self.d = try container.decode([String: A4432].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4430: Codable, Sendable {
    public let a: Int
    public let b: A4431
    public let c: [A4432]

    public init(a: Int,
        b: A4431,
        c: [A4432]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4431.self, forKey: "b")
        self.c = try container.decode([A4432].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4431: Codable, Sendable {
    public let a: Int
    public let b: A4432

    public init(a: Int,
        b: A4432) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4432.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4432: Codable, Sendable {
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

public final class A4433: Codable, Sendable {
    public let a: Int
    public let b: A4434
    public let c: [A4435]
    public let d: [String: A4436]

    public init(a: Int,
        b: A4434,
        c: [A4435],
        d: [String: A4436]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4434.self, forKey: "b")
        self.c = try container.decode([A4435].self, forKey: "c")
        self.d = try container.decode([String: A4436].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4434: Codable, Sendable {
    public let a: Int
    public let b: A4435
    public let c: [A4436]

    public init(a: Int,
        b: A4435,
        c: [A4436]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4435.self, forKey: "b")
        self.c = try container.decode([A4436].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4435: Codable, Sendable {
    public let a: Int
    public let b: A4436

    public init(a: Int,
        b: A4436) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4436.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4436: Codable, Sendable {
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

public final class A4437: Codable, Sendable {
    public let a: Int
    public let b: A4438
    public let c: [A4439]
    public let d: [String: A4440]

    public init(a: Int,
        b: A4438,
        c: [A4439],
        d: [String: A4440]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4438.self, forKey: "b")
        self.c = try container.decode([A4439].self, forKey: "c")
        self.d = try container.decode([String: A4440].self, forKey: "d")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
        try container.encode(d, forKey: "d")
    }
}

public final class A4438: Codable, Sendable {
    public let a: Int
    public let b: A4439
    public let c: [A4440]

    public init(a: Int,
        b: A4439,
        c: [A4440]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4439.self, forKey: "b")
        self.c = try container.decode([A4440].self, forKey: "c")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
        try container.encode(c, forKey: "c")
    }
}

public final class A4439: Codable, Sendable {
    public let a: Int
    public let b: A4440

    public init(a: Int,
        b: A4440) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A4440.self, forKey: "b")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encode(a, forKey: "a")
        try container.encode(b, forKey: "b")
    }
}

public final class A4440: Codable, Sendable {
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

