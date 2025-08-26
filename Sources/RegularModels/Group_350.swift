import Foundation

public final class A7001: Codable, Sendable {
    public let a: Int
    public let b: A7002
    public let c: [A7003]
    public let d: [String: A7004]

    public init(a: Int,
        b: A7002,
        c: [A7003],
        d: [String: A7004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A7002: Codable, Sendable {
    public let a: Int
    public let b: A7003
    public let c: [A7004]

    public init(a: Int,
        b: A7003,
        c: [A7004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7003: Codable, Sendable {
    public let a: Int
    public let b: A7004

    public init(a: Int,
        b: A7004) {
        self.a = a
        self.b = b
    }
}

public final class A7004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A7005: Codable, Sendable {
    public let a: Int
    public let b: A7006
    public let c: [A7007]
    public let d: [String: A7008]

    public init(a: Int,
        b: A7006,
        c: [A7007],
        d: [String: A7008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A7006: Codable, Sendable {
    public let a: Int
    public let b: A7007
    public let c: [A7008]

    public init(a: Int,
        b: A7007,
        c: [A7008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7007: Codable, Sendable {
    public let a: Int
    public let b: A7008

    public init(a: Int,
        b: A7008) {
        self.a = a
        self.b = b
    }
}

public final class A7008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A7009: Codable, Sendable {
    public let a: Int
    public let b: A7010
    public let c: [A7011]
    public let d: [String: A7012]

    public init(a: Int,
        b: A7010,
        c: [A7011],
        d: [String: A7012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A7010: Codable, Sendable {
    public let a: Int
    public let b: A7011
    public let c: [A7012]

    public init(a: Int,
        b: A7011,
        c: [A7012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7011: Codable, Sendable {
    public let a: Int
    public let b: A7012

    public init(a: Int,
        b: A7012) {
        self.a = a
        self.b = b
    }
}

public final class A7012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A7013: Codable, Sendable {
    public let a: Int
    public let b: A7014
    public let c: [A7015]
    public let d: [String: A7016]

    public init(a: Int,
        b: A7014,
        c: [A7015],
        d: [String: A7016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A7014: Codable, Sendable {
    public let a: Int
    public let b: A7015
    public let c: [A7016]

    public init(a: Int,
        b: A7015,
        c: [A7016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7015: Codable, Sendable {
    public let a: Int
    public let b: A7016

    public init(a: Int,
        b: A7016) {
        self.a = a
        self.b = b
    }
}

public final class A7016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A7017: Codable, Sendable {
    public let a: Int
    public let b: A7018
    public let c: [A7019]
    public let d: [String: A7020]

    public init(a: Int,
        b: A7018,
        c: [A7019],
        d: [String: A7020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A7018: Codable, Sendable {
    public let a: Int
    public let b: A7019
    public let c: [A7020]

    public init(a: Int,
        b: A7019,
        c: [A7020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7019: Codable, Sendable {
    public let a: Int
    public let b: A7020

    public init(a: Int,
        b: A7020) {
        self.a = a
        self.b = b
    }
}

public final class A7020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

