import Foundation

public final class A1: Codable, Sendable {
    public let a: Int
    public let b: A2
    public let c: [A3]
    public let d: [String: A4]

    public init(a: Int,
        b: A2,
        c: [A3],
        d: [String: A4]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2: Codable, Sendable {
    public let a: Int
    public let b: A3
    public let c: [A4]

    public init(a: Int,
        b: A3,
        c: [A4]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A3: Codable, Sendable {
    public let a: Int
    public let b: A4

    public init(a: Int,
        b: A4) {
        self.a = a
        self.b = b
    }
}

public final class A4: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A5: Codable, Sendable {
    public let a: Int
    public let b: A6
    public let c: [A7]
    public let d: [String: A8]

    public init(a: Int,
        b: A6,
        c: [A7],
        d: [String: A8]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A6: Codable, Sendable {
    public let a: Int
    public let b: A7
    public let c: [A8]

    public init(a: Int,
        b: A7,
        c: [A8]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A7: Codable, Sendable {
    public let a: Int
    public let b: A8

    public init(a: Int,
        b: A8) {
        self.a = a
        self.b = b
    }
}

public final class A8: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A9: Codable, Sendable {
    public let a: Int
    public let b: A10
    public let c: [A11]
    public let d: [String: A12]

    public init(a: Int,
        b: A10,
        c: [A11],
        d: [String: A12]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A10: Codable, Sendable {
    public let a: Int
    public let b: A11
    public let c: [A12]

    public init(a: Int,
        b: A11,
        c: [A12]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A11: Codable, Sendable {
    public let a: Int
    public let b: A12

    public init(a: Int,
        b: A12) {
        self.a = a
        self.b = b
    }
}

public final class A12: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A13: Codable, Sendable {
    public let a: Int
    public let b: A14
    public let c: [A15]
    public let d: [String: A16]

    public init(a: Int,
        b: A14,
        c: [A15],
        d: [String: A16]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A14: Codable, Sendable {
    public let a: Int
    public let b: A15
    public let c: [A16]

    public init(a: Int,
        b: A15,
        c: [A16]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A15: Codable, Sendable {
    public let a: Int
    public let b: A16

    public init(a: Int,
        b: A16) {
        self.a = a
        self.b = b
    }
}

public final class A16: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A17: Codable, Sendable {
    public let a: Int
    public let b: A18
    public let c: [A19]
    public let d: [String: A20]

    public init(a: Int,
        b: A18,
        c: [A19],
        d: [String: A20]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A18: Codable, Sendable {
    public let a: Int
    public let b: A19
    public let c: [A20]

    public init(a: Int,
        b: A19,
        c: [A20]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A19: Codable, Sendable {
    public let a: Int
    public let b: A20

    public init(a: Int,
        b: A20) {
        self.a = a
        self.b = b
    }
}

public final class A20: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

