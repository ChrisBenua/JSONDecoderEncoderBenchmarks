import Foundation

public final class A2001: Codable, Sendable {
    public let a: Int
    public let b: A2002
    public let c: [A2003]
    public let d: [String: A2004]

    public init(a: Int,
        b: A2002,
        c: [A2003],
        d: [String: A2004]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2002: Codable, Sendable {
    public let a: Int
    public let b: A2003
    public let c: [A2004]

    public init(a: Int,
        b: A2003,
        c: [A2004]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A2003: Codable, Sendable {
    public let a: Int
    public let b: A2004

    public init(a: Int,
        b: A2004) {
        self.a = a
        self.b = b
    }
}

public final class A2004: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A2005: Codable, Sendable {
    public let a: Int
    public let b: A2006
    public let c: [A2007]
    public let d: [String: A2008]

    public init(a: Int,
        b: A2006,
        c: [A2007],
        d: [String: A2008]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2006: Codable, Sendable {
    public let a: Int
    public let b: A2007
    public let c: [A2008]

    public init(a: Int,
        b: A2007,
        c: [A2008]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A2007: Codable, Sendable {
    public let a: Int
    public let b: A2008

    public init(a: Int,
        b: A2008) {
        self.a = a
        self.b = b
    }
}

public final class A2008: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A2009: Codable, Sendable {
    public let a: Int
    public let b: A2010
    public let c: [A2011]
    public let d: [String: A2012]

    public init(a: Int,
        b: A2010,
        c: [A2011],
        d: [String: A2012]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2010: Codable, Sendable {
    public let a: Int
    public let b: A2011
    public let c: [A2012]

    public init(a: Int,
        b: A2011,
        c: [A2012]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A2011: Codable, Sendable {
    public let a: Int
    public let b: A2012

    public init(a: Int,
        b: A2012) {
        self.a = a
        self.b = b
    }
}

public final class A2012: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A2013: Codable, Sendable {
    public let a: Int
    public let b: A2014
    public let c: [A2015]
    public let d: [String: A2016]

    public init(a: Int,
        b: A2014,
        c: [A2015],
        d: [String: A2016]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2014: Codable, Sendable {
    public let a: Int
    public let b: A2015
    public let c: [A2016]

    public init(a: Int,
        b: A2015,
        c: [A2016]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A2015: Codable, Sendable {
    public let a: Int
    public let b: A2016

    public init(a: Int,
        b: A2016) {
        self.a = a
        self.b = b
    }
}

public final class A2016: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

public final class A2017: Codable, Sendable {
    public let a: Int
    public let b: A2018
    public let c: [A2019]
    public let d: [String: A2020]

    public init(a: Int,
        b: A2018,
        c: [A2019],
        d: [String: A2020]) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}

public final class A2018: Codable, Sendable {
    public let a: Int
    public let b: A2019
    public let c: [A2020]

    public init(a: Int,
        b: A2019,
        c: [A2020]) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public final class A2019: Codable, Sendable {
    public let a: Int
    public let b: A2020

    public init(a: Int,
        b: A2020) {
        self.a = a
        self.b = b
    }
}

public final class A2020: Codable, Sendable {
    public let a: Int

    public init(a: Int) {
        self.a = a
    }
}

