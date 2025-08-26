import Foundation

public final class A5001: Codable, Sendable {
    public let a: Int
    public let b: A5002
    public let c: [A5003]
    public let d: [String: A5004]

    public init(a: Int,
        b: A5002,
        c: [A5003],
        d: [String: A5004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A5002: Codable, Sendable {
    public let a: Int
    public let b: A5003
    public let c: [A5004]

    public init(a: Int,
        b: A5003,
        c: [A5004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A5003: Codable, Sendable {
    public let a: Int
    public let b: A5004

    public init(a: Int,
        b: A5004) {
        self.a = a
        self.b = b
    }
}

public final class A5004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A5005: Codable, Sendable {
    public let a: Int
    public let b: A5006
    public let c: [A5007]
    public let d: [String: A5008]

    public init(a: Int,
        b: A5006,
        c: [A5007],
        d: [String: A5008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A5006: Codable, Sendable {
    public let a: Int
    public let b: A5007
    public let c: [A5008]

    public init(a: Int,
        b: A5007,
        c: [A5008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A5007: Codable, Sendable {
    public let a: Int
    public let b: A5008

    public init(a: Int,
        b: A5008) {
        self.a = a
        self.b = b
    }
}

public final class A5008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A5009: Codable, Sendable {
    public let a: Int
    public let b: A5010
    public let c: [A5011]
    public let d: [String: A5012]

    public init(a: Int,
        b: A5010,
        c: [A5011],
        d: [String: A5012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A5010: Codable, Sendable {
    public let a: Int
    public let b: A5011
    public let c: [A5012]

    public init(a: Int,
        b: A5011,
        c: [A5012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A5011: Codable, Sendable {
    public let a: Int
    public let b: A5012

    public init(a: Int,
        b: A5012) {
        self.a = a
        self.b = b
    }
}

public final class A5012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A5013: Codable, Sendable {
    public let a: Int
    public let b: A5014
    public let c: [A5015]
    public let d: [String: A5016]

    public init(a: Int,
        b: A5014,
        c: [A5015],
        d: [String: A5016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A5014: Codable, Sendable {
    public let a: Int
    public let b: A5015
    public let c: [A5016]

    public init(a: Int,
        b: A5015,
        c: [A5016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A5015: Codable, Sendable {
    public let a: Int
    public let b: A5016

    public init(a: Int,
        b: A5016) {
        self.a = a
        self.b = b
    }
}

public final class A5016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A5017: Codable, Sendable {
    public let a: Int
    public let b: A5018
    public let c: [A5019]
    public let d: [String: A5020]

    public init(a: Int,
        b: A5018,
        c: [A5019],
        d: [String: A5020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A5018: Codable, Sendable {
    public let a: Int
    public let b: A5019
    public let c: [A5020]

    public init(a: Int,
        b: A5019,
        c: [A5020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A5019: Codable, Sendable {
    public let a: Int
    public let b: A5020

    public init(a: Int,
        b: A5020) {
        self.a = a
        self.b = b
    }
}

public final class A5020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

