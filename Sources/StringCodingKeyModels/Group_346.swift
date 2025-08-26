import Foundation

public final class A6921: Codable, Sendable {
    public let a: Int
    public let b: A6922
    public let c: [A6923]
    public let d: [String: A6924]

    public init(a: Int,
        b: A6922,
        c: [A6923],
        d: [String: A6924]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6922.self, forKey: "b")
        self.c = try container.decode([A6923].self, forKey: "c")
        self.d = try container.decode([String: A6924].self, forKey: "d")
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

public final class A6922: Codable, Sendable {
    public let a: Int
    public let b: A6923
    public let c: [A6924]

    public init(a: Int,
        b: A6923,
        c: [A6924]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6923.self, forKey: "b")
        self.c = try container.decode([A6924].self, forKey: "c")
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

public final class A6923: Codable, Sendable {
    public let a: Int
    public let b: A6924

    public init(a: Int,
        b: A6924) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6924.self, forKey: "b")
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

public final class A6924: Codable, Sendable {
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

public final class A6925: Codable, Sendable {
    public let a: Int
    public let b: A6926
    public let c: [A6927]
    public let d: [String: A6928]

    public init(a: Int,
        b: A6926,
        c: [A6927],
        d: [String: A6928]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6926.self, forKey: "b")
        self.c = try container.decode([A6927].self, forKey: "c")
        self.d = try container.decode([String: A6928].self, forKey: "d")
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

public final class A6926: Codable, Sendable {
    public let a: Int
    public let b: A6927
    public let c: [A6928]

    public init(a: Int,
        b: A6927,
        c: [A6928]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6927.self, forKey: "b")
        self.c = try container.decode([A6928].self, forKey: "c")
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

public final class A6927: Codable, Sendable {
    public let a: Int
    public let b: A6928

    public init(a: Int,
        b: A6928) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6928.self, forKey: "b")
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

public final class A6928: Codable, Sendable {
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

public final class A6929: Codable, Sendable {
    public let a: Int
    public let b: A6930
    public let c: [A6931]
    public let d: [String: A6932]

    public init(a: Int,
        b: A6930,
        c: [A6931],
        d: [String: A6932]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6930.self, forKey: "b")
        self.c = try container.decode([A6931].self, forKey: "c")
        self.d = try container.decode([String: A6932].self, forKey: "d")
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

public final class A6930: Codable, Sendable {
    public let a: Int
    public let b: A6931
    public let c: [A6932]

    public init(a: Int,
        b: A6931,
        c: [A6932]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6931.self, forKey: "b")
        self.c = try container.decode([A6932].self, forKey: "c")
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

public final class A6931: Codable, Sendable {
    public let a: Int
    public let b: A6932

    public init(a: Int,
        b: A6932) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6932.self, forKey: "b")
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

public final class A6932: Codable, Sendable {
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

public final class A6933: Codable, Sendable {
    public let a: Int
    public let b: A6934
    public let c: [A6935]
    public let d: [String: A6936]

    public init(a: Int,
        b: A6934,
        c: [A6935],
        d: [String: A6936]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6934.self, forKey: "b")
        self.c = try container.decode([A6935].self, forKey: "c")
        self.d = try container.decode([String: A6936].self, forKey: "d")
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

public final class A6934: Codable, Sendable {
    public let a: Int
    public let b: A6935
    public let c: [A6936]

    public init(a: Int,
        b: A6935,
        c: [A6936]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6935.self, forKey: "b")
        self.c = try container.decode([A6936].self, forKey: "c")
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

public final class A6935: Codable, Sendable {
    public let a: Int
    public let b: A6936

    public init(a: Int,
        b: A6936) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6936.self, forKey: "b")
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

public final class A6936: Codable, Sendable {
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

public final class A6937: Codable, Sendable {
    public let a: Int
    public let b: A6938
    public let c: [A6939]
    public let d: [String: A6940]

    public init(a: Int,
        b: A6938,
        c: [A6939],
        d: [String: A6940]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6938.self, forKey: "b")
        self.c = try container.decode([A6939].self, forKey: "c")
        self.d = try container.decode([String: A6940].self, forKey: "d")
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

public final class A6938: Codable, Sendable {
    public let a: Int
    public let b: A6939
    public let c: [A6940]

    public init(a: Int,
        b: A6939,
        c: [A6940]) {
        self.a = a
        self.b = b
        self.c = c
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6939.self, forKey: "b")
        self.c = try container.decode([A6940].self, forKey: "c")
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

public final class A6939: Codable, Sendable {
    public let a: Int
    public let b: A6940

    public init(a: Int,
        b: A6940) {
        self.a = a
        self.b = b
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        self.a = try container.decode(Int.self, forKey: "a")
        self.b = try container.decode(A6940.self, forKey: "b")
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

public final class A6940: Codable, Sendable {
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

