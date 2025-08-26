import Foundation

// swiftlint:disable all
internal struct JSONWriter {

    // Structures with container nesting deeper than this limit are not valid.
    private static let maximumRecursionDepth = 512

    private var indent = 0
    private let pretty: Bool
    private let sortedKeys: Bool
    private let withoutEscapingSlashes: Bool

    var bytes = [UInt8]()

    init(options: JSONEncoder.OutputFormatting) {
        self.pretty = options.contains(.prettyPrinted)
        self.sortedKeys = options.contains(.sortedKeys)
        self.withoutEscapingSlashes = options.contains(.withoutEscapingSlashes)
    }

    mutating func serializeJSON(_ value: JSONEncoderValue, depth: Int = 0) throws {
        switch value {
        case let .string(str):
            serializeString(str)
        case let .bool(boolValue):
            writer(boolValue ? "true" : "false")
        case let .number(numberStr):
            writer(contentsOf: numberStr.utf8)
        case let .array(array):
            try serializeArray(array, depth: depth + 1)
        case let .nonPrettyDirectArray(arrayRepresentation):
            writer(contentsOf: arrayRepresentation)
        case let .directArray(bytes, lengths):
            try serializePreformattedByteArray(bytes, lengths, depth: depth + 1)
        case let .object(object):
            try serializeObject(object, depth: depth + 1)
        case .null:
            writer("null")
        }
    }

    @inline(__always)
    mutating func writer(_ string: StaticString) {
        writer(pointer: string.utf8Start, count: string.utf8CodeUnitCount)
    }

    @inline(__always)
    mutating func writer<S: Sequence>(contentsOf sequence: S) where S.Element == UInt8 {
        bytes.append(contentsOf: sequence)
    }

    @inline(__always)
    mutating func writer(ascii: UInt8) {
        bytes.append(ascii)
    }

    @inline(__always)
    mutating func writer(pointer: UnsafePointer<UInt8>, count: Int) {
        bytes.append(contentsOf: UnsafeBufferPointer(start: pointer, count: count))
    }

    @inline(__always)
    mutating func serializeStringContents(_ str: String) -> Int {
        let unquotedStringStart = bytes.endIndex
        var mutStr = str
        mutStr.withUTF8 {

            @inline(__always)
            func appendAccumulatedBytes(from mark: UnsafePointer<UInt8>, to cursor: UnsafePointer<UInt8>, followedByContentsOf sequence: [UInt8]) {
                if cursor > mark {
                    writer(pointer: mark, count: cursor - mark)
                }
                writer(contentsOf: sequence)
            }

            @inline(__always)
            func valueToASCII(_ value: UInt8) -> UInt8 {
                switch value {
                case 0 ... 9:
                    return value &+ UInt8(ascii: "0")
                case 10 ... 15:
                    return value &- 10 &+ UInt8(ascii: "a")
                default:
                    preconditionFailure()
                }
            }

            var cursor = $0.baseAddress!
            let end = $0.baseAddress! + $0.count
            var mark = cursor
            while cursor < end {
                switch cursor.pointee {
                case ._quote:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, ._quote])
                case ._backslash:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, ._backslash])
                case ._slash where !withoutEscapingSlashes:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, ._forwardslash])
                case 0x8:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "b")])
                case 0xC:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "f")])
                case ._newline:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "n")])
                case ._return:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "r")])
                case ._tab:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "t")])
                case 0x0 ... 0xF:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "u"), UInt8(ascii: "0"), UInt8(ascii: "0"), UInt8(ascii: "0")])
                    writer(ascii: valueToASCII(cursor.pointee))
                case 0x10 ... 0x1F:
                    appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [._backslash, UInt8(ascii: "u"), UInt8(ascii: "0"), UInt8(ascii: "0")])
                    writer(ascii: valueToASCII(cursor.pointee / 16))
                    writer(ascii: valueToASCII(cursor.pointee % 16))
                default:
                    // Accumulate this byte
                    cursor += 1
                    continue
                }

                cursor += 1
                mark = cursor // Start accumulating bytes starting after this escaped byte.
            }

            appendAccumulatedBytes(from: mark, to: cursor, followedByContentsOf: [])
        }
        let unquotedStringLength = unquotedStringStart.distance(to: bytes.endIndex)
        return unquotedStringLength
    }

    @discardableResult
    mutating func serializeString(_ str: String) -> Int {
        writer(ascii: ._quote)
        defer {
            writer(ascii: ._quote)
        }
        return serializeStringContents(str) + 2 // +2 for quotes.
    }

    mutating func serializeArray(_ array: [JSONEncoderValue], depth: Int) throws {
        guard depth < Self.maximumRecursionDepth else {
            throw JSONError.tooManyNestedArraysOrDictionaries()
        }

        writer(ascii: ._openbracket)
        if pretty {
            writer(ascii: ._newline)
            incIndent()
        }

        var first = true
        for elem in array {
            if first {
                first = false
            } else if pretty {
                writer(contentsOf: [._comma, ._newline])
            } else {
                writer(ascii: ._comma)
            }
            if pretty {
                writeIndent()
            }
            try serializeJSON(elem, depth: depth)
        }
        if pretty {
            writer(ascii: ._newline)
            decAndWriteIndent()
        }
        writer(ascii: ._closebracket)
    }

    mutating func serializePreformattedByteArray(_ bytes: [UInt8], _ lengths: [Int], depth: Int) throws {
        guard depth < Self.maximumRecursionDepth else {
            throw JSONError.tooManyNestedArraysOrDictionaries()
        }

        writer(ascii: ._openbracket)
        if pretty {
            writer(ascii: ._newline)
            incIndent()
        }

        var lowerBound: [UInt8].Index = bytes.startIndex

        var first = true
        for length in lengths {
            if first {
                first = false
            } else if pretty {
                writer(contentsOf: [._comma, ._newline])
            } else {
                writer(ascii: ._comma)
            }
            if pretty {
                writeIndent()
            }

            // Do NOT call `serializeString` here! The input strings have already been formatted exactly as they need to be for direct JSON output, including any requisite quotes or escaped characters for strings.
            let upperBound = lowerBound + length
            writer(contentsOf: bytes[lowerBound ..< upperBound])
            lowerBound = upperBound
        }
        if pretty {
            writer(ascii: ._newline)
            decAndWriteIndent()
        }
        writer(ascii: ._closebracket)
    }

    mutating func serializeObject(_ dict: [String: JSONEncoderValue], depth: Int) throws {
        guard depth < Self.maximumRecursionDepth else {
            throw JSONError.tooManyNestedArraysOrDictionaries()
        }

        writer(ascii: ._openbrace)
        if pretty {
            writer(ascii: ._newline)
            incIndent()
            if !dict.isEmpty {
                writeIndent()
            }
        }

        var first = true

        func serializeObjectElement(key: String, value: JSONEncoderValue, depth: Int) throws {
            if first {
                first = false
            } else if pretty {
                writer(contentsOf: [._comma, ._newline])
                writeIndent()
            } else {
                writer(ascii: ._comma)
            }
            serializeString(key)
            pretty ? writer(contentsOf: [._space, ._colon, ._space]) : writer(ascii: ._colon)
            try serializeJSON(value, depth: depth)
        }

        if sortedKeys {
            #if FOUNDATION_FRAMEWORK
                var compatibilitySorted = false
                if JSONEncoder.compatibility1 {
                    // If applicable, use the old NSString-based sorting with appropriate options
                    compatibilitySorted = true
                    let nsKeysAndValues = dict.map {
                        (key: $0.key as NSString, value: $0.value)
                    }
                    let elems = nsKeysAndValues.sorted(by: { a, b in
                        let options: String.CompareOptions = [.numeric, .caseInsensitive, .forcedOrdering]
                        let range = NSMakeRange(0, a.key.length)
                        let locale = Locale.system
                        return a.key.compare(b.key as String, options: options, range: range, locale: locale) == .orderedAscending
                    })
                    for elem in elems {
                        try serializeObjectElement(key: elem.key as String, value: elem.value, depth: depth)
                    }
                }
            #else
                let compatibilitySorted = false
            #endif

            // If we didn't use the NSString-based compatibility sorting, sort lexicographically by the UTF-8 view
            if !compatibilitySorted {
                let elems = dict.sorted { a, b in
                    a.key.utf8.lexicographicallyPrecedes(b.key.utf8)
                }
                for elem in elems {
                    try serializeObjectElement(key: elem.key as String, value: elem.value, depth: depth)
                }
            }
        } else {
            for (key, value) in dict {
                try serializeObjectElement(key: key, value: value, depth: depth)
            }
        }

        if pretty {
            writer("\n")
            decAndWriteIndent()
        }
        writer("}")
    }

    mutating func incIndent() {
        indent += 1
    }

    mutating func decAndWriteIndent() {
        indent -= 1
        writeIndent()
    }

    mutating func writeIndent() {
        switch indent {
        case 0: break
        case 1: writer("  ")
        case 2: writer("    ")
        case 3: writer("      ")
        case 4: writer("        ")
        case 5: writer("          ")
        case 6: writer("            ")
        case 7: writer("              ")
        case 8: writer("                ")
        case 9: writer("                  ")
        case 10: writer("                    ")
        default:
            for _ in 0 ..< indent {
                writer("  ")
            }
        }
    }
}

// swiftlint:enable all
