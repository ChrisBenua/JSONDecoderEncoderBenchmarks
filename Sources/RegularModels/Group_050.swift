import Foundation

public final class A1001: Codable, Sendable {
    public let a: Int
    public let b: A1002
    public let c: [A1003]
    public let d: [String: A1004]

    public init(a: Int,
        b: A1002,
        c: [A1003],
        d: [String: A1004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A1002: Codable, Sendable {
    public let a: Int
    public let b: A1003
    public let c: [A1004]

    public init(a: Int,
        b: A1003,
        c: [A1004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A1003: Codable, Sendable {
    public let a: Int
    public let b: A1004

    public init(a: Int,
        b: A1004) {
        self.a = a
        self.b = b
    }
}

public final class A1004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A1005: Codable, Sendable {
    public let a: Int
    public let b: A1006
    public let c: [A1007]
    public let d: [String: A1008]

    public init(a: Int,
        b: A1006,
        c: [A1007],
        d: [String: A1008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A1006: Codable, Sendable {
    public let a: Int
    public let b: A1007
    public let c: [A1008]

    public init(a: Int,
        b: A1007,
        c: [A1008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A1007: Codable, Sendable {
    public let a: Int
    public let b: A1008

    public init(a: Int,
        b: A1008) {
        self.a = a
        self.b = b
    }
}

public final class A1008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A1009: Codable, Sendable {
    public let a: Int
    public let b: A1010
    public let c: [A1011]
    public let d: [String: A1012]

    public init(a: Int,
        b: A1010,
        c: [A1011],
        d: [String: A1012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A1010: Codable, Sendable {
    public let a: Int
    public let b: A1011
    public let c: [A1012]

    public init(a: Int,
        b: A1011,
        c: [A1012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A1011: Codable, Sendable {
    public let a: Int
    public let b: A1012

    public init(a: Int,
        b: A1012) {
        self.a = a
        self.b = b
    }
}

public final class A1012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A1013: Codable, Sendable {
    public let a: Int
    public let b: A1014
    public let c: [A1015]
    public let d: [String: A1016]

    public init(a: Int,
        b: A1014,
        c: [A1015],
        d: [String: A1016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A1014: Codable, Sendable {
    public let a: Int
    public let b: A1015
    public let c: [A1016]

    public init(a: Int,
        b: A1015,
        c: [A1016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A1015: Codable, Sendable {
    public let a: Int
    public let b: A1016

    public init(a: Int,
        b: A1016) {
        self.a = a
        self.b = b
    }
}

public final class A1016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A1017: Codable, Sendable {
    public let a: Int
    public let b: A1018
    public let c: [A1019]
    public let d: [String: A1020]

    public init(a: Int,
        b: A1018,
        c: [A1019],
        d: [String: A1020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A1018: Codable, Sendable {
    public let a: Int
    public let b: A1019
    public let c: [A1020]

    public init(a: Int,
        b: A1019,
        c: [A1020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A1019: Codable, Sendable {
    public let a: Int
    public let b: A1020

    public init(a: Int,
        b: A1020) {
        self.a = a
        self.b = b
    }
}

public final class A1020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

