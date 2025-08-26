import Foundation

public final class A9001: Codable, Sendable {
    public let a: Int
    public let b: A9002
    public let c: [A9003]
    public let d: [String: A9004]

    public init(a: Int,
        b: A9002,
        c: [A9003],
        d: [String: A9004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A9002: Codable, Sendable {
    public let a: Int
    public let b: A9003
    public let c: [A9004]

    public init(a: Int,
        b: A9003,
        c: [A9004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A9003: Codable, Sendable {
    public let a: Int
    public let b: A9004

    public init(a: Int,
        b: A9004) {
        self.a = a
        self.b = b
    }
}

public final class A9004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A9005: Codable, Sendable {
    public let a: Int
    public let b: A9006
    public let c: [A9007]
    public let d: [String: A9008]

    public init(a: Int,
        b: A9006,
        c: [A9007],
        d: [String: A9008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A9006: Codable, Sendable {
    public let a: Int
    public let b: A9007
    public let c: [A9008]

    public init(a: Int,
        b: A9007,
        c: [A9008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A9007: Codable, Sendable {
    public let a: Int
    public let b: A9008

    public init(a: Int,
        b: A9008) {
        self.a = a
        self.b = b
    }
}

public final class A9008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A9009: Codable, Sendable {
    public let a: Int
    public let b: A9010
    public let c: [A9011]
    public let d: [String: A9012]

    public init(a: Int,
        b: A9010,
        c: [A9011],
        d: [String: A9012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A9010: Codable, Sendable {
    public let a: Int
    public let b: A9011
    public let c: [A9012]

    public init(a: Int,
        b: A9011,
        c: [A9012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A9011: Codable, Sendable {
    public let a: Int
    public let b: A9012

    public init(a: Int,
        b: A9012) {
        self.a = a
        self.b = b
    }
}

public final class A9012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A9013: Codable, Sendable {
    public let a: Int
    public let b: A9014
    public let c: [A9015]
    public let d: [String: A9016]

    public init(a: Int,
        b: A9014,
        c: [A9015],
        d: [String: A9016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A9014: Codable, Sendable {
    public let a: Int
    public let b: A9015
    public let c: [A9016]

    public init(a: Int,
        b: A9015,
        c: [A9016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A9015: Codable, Sendable {
    public let a: Int
    public let b: A9016

    public init(a: Int,
        b: A9016) {
        self.a = a
        self.b = b
    }
}

public final class A9016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A9017: Codable, Sendable {
    public let a: Int
    public let b: A9018
    public let c: [A9019]
    public let d: [String: A9020]

    public init(a: Int,
        b: A9018,
        c: [A9019],
        d: [String: A9020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A9018: Codable, Sendable {
    public let a: Int
    public let b: A9019
    public let c: [A9020]

    public init(a: Int,
        b: A9019,
        c: [A9020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A9019: Codable, Sendable {
    public let a: Int
    public let b: A9020

    public init(a: Int,
        b: A9020) {
        self.a = a
        self.b = b
    }
}

public final class A9020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

