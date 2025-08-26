// swiftlint:disable all
extension UInt8 {
    internal static var _space: UInt8 { UInt8(ascii: " ") }
    internal static var _return: UInt8 { UInt8(ascii: "\r") }
    internal static var _newline: UInt8 { UInt8(ascii: "\n") }
    internal static var _tab: UInt8 { UInt8(ascii: "\t") }

    internal static var _colon: UInt8 { UInt8(ascii: ":") }
    internal static var _comma: UInt8 { UInt8(ascii: ",") }

    internal static var _openbrace: UInt8 { UInt8(ascii: "{") }
    internal static var _closebrace: UInt8 { UInt8(ascii: "}") }

    internal static var _openbracket: UInt8 { UInt8(ascii: "[") }
    internal static var _closebracket: UInt8 { UInt8(ascii: "]") }

    internal static var _quote: UInt8 { UInt8(ascii: "\"") }
    internal static var _backslash: UInt8 { UInt8(ascii: "\\") }
    internal static var _forwardslash: UInt8 { UInt8(ascii: "/") }

    internal static var _minus: UInt8 { UInt8(ascii: "-") }
    internal static var _plus: UInt8 { UInt8(ascii: "+") }

    internal static var _e: UInt8 { UInt8(ascii: "e") }
    internal static var _E: UInt8 { UInt8(ascii: "E") }

    static var _verticalTab: UInt8 { UInt8(0x0B) }
    static var _formFeed: UInt8 { UInt8(0x0C) }
    static var _nbsp: UInt8 { UInt8(0xA0) }
    static var _asterisk: UInt8 { UInt8(ascii: "*") }
    static var _slash: UInt8 { UInt8(ascii: "/") }
    static var _singleQuote: UInt8 { UInt8(ascii: "'") }
    static var _dollar: UInt8 { UInt8(ascii: "$") }
    static var _underscore: UInt8 { UInt8(ascii: "_") }

    internal var digitValue: Int? {
        guard _asciiNumbers.contains(self) else { return nil }
        return Int(self &- UInt8(ascii: "0"))
    }
}

internal var _asciiNumbers: ClosedRange<UInt8> { UInt8(ascii: "0") ... UInt8(ascii: "9") }
internal var _hexCharsUpper: ClosedRange<UInt8> { UInt8(ascii: "A") ... UInt8(ascii: "F") }
internal var _hexCharsLower: ClosedRange<UInt8> { UInt8(ascii: "a") ... UInt8(ascii: "f") }
internal var _allLettersUpper: ClosedRange<UInt8> { UInt8(ascii: "A") ... UInt8(ascii: "Z") }
internal var _allLettersLower: ClosedRange<UInt8> { UInt8(ascii: "a") ... UInt8(ascii: "z") }
// swiftlint:enable all
