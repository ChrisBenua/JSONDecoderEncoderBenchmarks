import Foundation

public final class A3001: Codable, Sendable {
    public let a: Int
    public let b: A3002
    public let c: [A3003]
    public let d: [String: A3004]

    public init(a: Int,
        b: A3002,
        c: [A3003],
        d: [String: A3004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A3002: Codable, Sendable {
    public let a: Int
    public let b: A3003
    public let c: [A3004]

    public init(a: Int,
        b: A3003,
        c: [A3004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3003: Codable, Sendable {
    public let a: Int
    public let b: A3004

    public init(a: Int,
        b: A3004) {
        self.a = a
        self.b = b
    }
}

public final class A3004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A3005: Codable, Sendable {
    public let a: Int
    public let b: A3006
    public let c: [A3007]
    public let d: [String: A3008]

    public init(a: Int,
        b: A3006,
        c: [A3007],
        d: [String: A3008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A3006: Codable, Sendable {
    public let a: Int
    public let b: A3007
    public let c: [A3008]

    public init(a: Int,
        b: A3007,
        c: [A3008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3007: Codable, Sendable {
    public let a: Int
    public let b: A3008

    public init(a: Int,
        b: A3008) {
        self.a = a
        self.b = b
    }
}

public final class A3008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A3009: Codable, Sendable {
    public let a: Int
    public let b: A3010
    public let c: [A3011]
    public let d: [String: A3012]

    public init(a: Int,
        b: A3010,
        c: [A3011],
        d: [String: A3012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A3010: Codable, Sendable {
    public let a: Int
    public let b: A3011
    public let c: [A3012]

    public init(a: Int,
        b: A3011,
        c: [A3012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3011: Codable, Sendable {
    public let a: Int
    public let b: A3012

    public init(a: Int,
        b: A3012) {
        self.a = a
        self.b = b
    }
}

public final class A3012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A3013: Codable, Sendable {
    public let a: Int
    public let b: A3014
    public let c: [A3015]
    public let d: [String: A3016]

    public init(a: Int,
        b: A3014,
        c: [A3015],
        d: [String: A3016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A3014: Codable, Sendable {
    public let a: Int
    public let b: A3015
    public let c: [A3016]

    public init(a: Int,
        b: A3015,
        c: [A3016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3015: Codable, Sendable {
    public let a: Int
    public let b: A3016

    public init(a: Int,
        b: A3016) {
        self.a = a
        self.b = b
    }
}

public final class A3016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A3017: Codable, Sendable {
    public let a: Int
    public let b: A3018
    public let c: [A3019]
    public let d: [String: A3020]

    public init(a: Int,
        b: A3018,
        c: [A3019],
        d: [String: A3020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A3018: Codable, Sendable {
    public let a: Int
    public let b: A3019
    public let c: [A3020]

    public init(a: Int,
        b: A3019,
        c: [A3020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3019: Codable, Sendable {
    public let a: Int
    public let b: A3020

    public init(a: Int,
        b: A3020) {
        self.a = a
        self.b = b
    }
}

public final class A3020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

