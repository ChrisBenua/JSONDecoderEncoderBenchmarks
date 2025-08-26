import Foundation

public final class A6001: Codable, Sendable {
    public let a: Int
    public let b: A6002
    public let c: [A6003]
    public let d: [String: A6004]

    public init(a: Int,
        b: A6002,
        c: [A6003],
        d: [String: A6004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6002: Codable, Sendable {
    public let a: Int
    public let b: A6003
    public let c: [A6004]

    public init(a: Int,
        b: A6003,
        c: [A6004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A6003: Codable, Sendable {
    public let a: Int
    public let b: A6004

    public init(a: Int,
        b: A6004) {
        self.a = a
        self.b = b
    }
}

public final class A6004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A6005: Codable, Sendable {
    public let a: Int
    public let b: A6006
    public let c: [A6007]
    public let d: [String: A6008]

    public init(a: Int,
        b: A6006,
        c: [A6007],
        d: [String: A6008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6006: Codable, Sendable {
    public let a: Int
    public let b: A6007
    public let c: [A6008]

    public init(a: Int,
        b: A6007,
        c: [A6008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A6007: Codable, Sendable {
    public let a: Int
    public let b: A6008

    public init(a: Int,
        b: A6008) {
        self.a = a
        self.b = b
    }
}

public final class A6008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A6009: Codable, Sendable {
    public let a: Int
    public let b: A6010
    public let c: [A6011]
    public let d: [String: A6012]

    public init(a: Int,
        b: A6010,
        c: [A6011],
        d: [String: A6012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6010: Codable, Sendable {
    public let a: Int
    public let b: A6011
    public let c: [A6012]

    public init(a: Int,
        b: A6011,
        c: [A6012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A6011: Codable, Sendable {
    public let a: Int
    public let b: A6012

    public init(a: Int,
        b: A6012) {
        self.a = a
        self.b = b
    }
}

public final class A6012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A6013: Codable, Sendable {
    public let a: Int
    public let b: A6014
    public let c: [A6015]
    public let d: [String: A6016]

    public init(a: Int,
        b: A6014,
        c: [A6015],
        d: [String: A6016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6014: Codable, Sendable {
    public let a: Int
    public let b: A6015
    public let c: [A6016]

    public init(a: Int,
        b: A6015,
        c: [A6016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A6015: Codable, Sendable {
    public let a: Int
    public let b: A6016

    public init(a: Int,
        b: A6016) {
        self.a = a
        self.b = b
    }
}

public final class A6016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A6017: Codable, Sendable {
    public let a: Int
    public let b: A6018
    public let c: [A6019]
    public let d: [String: A6020]

    public init(a: Int,
        b: A6018,
        c: [A6019],
        d: [String: A6020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6018: Codable, Sendable {
    public let a: Int
    public let b: A6019
    public let c: [A6020]

    public init(a: Int,
        b: A6019,
        c: [A6020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A6019: Codable, Sendable {
    public let a: Int
    public let b: A6020

    public init(a: Int,
        b: A6020) {
        self.a = a
        self.b = b
    }
}

public final class A6020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

