// swiftlint:disable all
import Foundation


enum JSONError: Swift.Error, Equatable {
    struct SourceLocation: Equatable {
        let line: Int
        let column: Int
        let index: Int

        static func sourceLocation(
            at location: BufferViewIndex<UInt8>, fullSource: BufferView<UInt8>
        ) -> SourceLocation {
            precondition(fullSource.startIndex <= location && location <= fullSource.endIndex)
            var index = fullSource.startIndex
            var line = 1
            var col = 0
            let end = min(location.advanced(by: 1), fullSource.endIndex)
            while index < end {
                switch fullSource[index] {
                case ._return:
                    let next = fullSource.index(after: index)
                    if next <= location, fullSource[next] == ._newline {
                        index = next
                    }
                    line += 1
                    col = 0
                case ._newline:
                    line += 1
                    col = 0
                default:
                    col += 1
                }
                fullSource.formIndex(after: &index)
            }
            let offset = fullSource.distance(from: fullSource.startIndex, to: location)
            return SourceLocation(line: line, column: col, index: offset)
        }
    }

    case cannotConvertEntireInputDataToUTF8
    case cannotConvertInputStringDataToUTF8(location: SourceLocation)
    case unexpectedCharacter(context: String? = nil, ascii: UInt8, location: SourceLocation)
    case unexpectedEndOfFile
    case tooManyNestedArraysOrDictionaries(location: SourceLocation? = nil)
    case invalidHexDigitSequence(String, location: SourceLocation)
    case invalidEscapedNullValue(location: SourceLocation)
    case invalidSpecialValue(expected: String, location: SourceLocation)
    case unexpectedEscapedCharacter(ascii: UInt8, location: SourceLocation)
    case unescapedControlCharacterInString(ascii: UInt8, location: SourceLocation)
    case expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location: SourceLocation)
    case couldNotCreateUnicodeScalarFromUInt32(location: SourceLocation, unicodeScalarValue: UInt32)
    case numberWithLeadingZero(location: SourceLocation)
    case numberIsNotRepresentableInSwift(parsed: String)
    case singleFragmentFoundButNotAllowed

    // JSON5

    case unterminatedBlockComment

    var debugDescription: String {
        switch self {
        case .cannotConvertEntireInputDataToUTF8:
            return mobs("Unable to convert data to a string using the detected encoding. The data may be corrupt.")
        case let .cannotConvertInputStringDataToUTF8(location):
            let line = location.line
            let col = location.column
            return mobs("Unable to convert data to a string around line \(line), column \(col).")
        case let .unexpectedCharacter(context, ascii, location):
            let line = location.line
            let col = location.column
            if let context {
                return mobs("Unexpected character '\(String(UnicodeScalar(ascii)))' \(context) around line \(line), column \(col).")
            } else {
                return mobs("Unexpected character '\(String(UnicodeScalar(ascii)))' around line \(line), column \(col).")
            }
        case .unexpectedEndOfFile:
            return mobs("Unexpected end of file")
        case let .tooManyNestedArraysOrDictionaries(location):
            if let location {
                let line = location.line
                let col = location.column
                return mobs("Too many nested arrays or dictionaries around line \(line), column \(col).")
            } else {
                return mobs("Too many nested arrays or dictionaries.")
            }
        case let .invalidHexDigitSequence(hexSequence, location):
            let line = location.line
            let col = location.column
            return mobs("Invalid hex digit in unicode escape sequence '\(hexSequence)' around line \(line), column \(col).")
        case let .invalidEscapedNullValue(location):
            let line = location.line
            let col = location.column
            return mobs("Unsupported escaped null around line \(line), column \(col).")
        case let .invalidSpecialValue(expected, location):
            let line = location.line
            let col = location.column
            return mobs("Invalid \(expected) value around line \(line), column \(col).")
        case let .unexpectedEscapedCharacter(ascii, location):
            let line = location.line
            let col = location.column
            return mobs("Invalid escape sequence '\(String(UnicodeScalar(ascii)))' around line \(line), column \(col).")
        case let .unescapedControlCharacterInString(ascii, location):
            let line = location.line
            let col = location.column
            return mobs("Unescaped control character '0x\(String(ascii, radix: 16))' around line \(line), column \(col).")
        case let .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location):
            let line = location.line
            let col = location.column
            return mobs("Missing low code point in surrogate pair around line \(line), column \(col).")
        case let .couldNotCreateUnicodeScalarFromUInt32(location, unicodeScalarValue):
            let line = location.line
            let col = location.column
            return mobs("Invalid unicode scalar value '0x\(String(unicodeScalarValue, radix: 16))' around line \(line), column \(col).")
        case let .numberWithLeadingZero(location):
            let line = location.line
            let col = location.column
            return mobs("Number with leading zero around line \(line), column \(col).")
        case let .numberIsNotRepresentableInSwift(parsed):
            return mobs("Number \(parsed) is not representable in Swift.")
        case .singleFragmentFoundButNotAllowed:
            return mobs("JSON input did not start with array or object as required by options.")

            // JSON5

        case .unterminatedBlockComment:
            return mobs("Unterminated block comment")
        }
    }

    var sourceLocation: SourceLocation? {
        switch self {
        case let .cannotConvertInputStringDataToUTF8(location), let .unexpectedCharacter(_, _, location):
            return location
        case let .tooManyNestedArraysOrDictionaries(location):
            return location
        case let .invalidHexDigitSequence(_, location), let .invalidEscapedNullValue(location), let .invalidSpecialValue(_, location):
            return location
        case let .unexpectedEscapedCharacter(_, location), let .unescapedControlCharacterInString(_, location), let .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(location):
            return location
        case let .couldNotCreateUnicodeScalarFromUInt32(location, _), let .numberWithLeadingZero(location):
            return location
        default:
            return nil
        }
    }

    var nsError: NSError {
        var userInfo: [String: Any] = [
            NSDebugDescriptionErrorKey: self.debugDescription
        ]
        if let location = self.sourceLocation {
            userInfo[mobs("NSJSONSerializationErrorIndex")] = location.index
        }
        return .init(domain: NSCocoaErrorDomain, code: CocoaError.propertyListReadCorrupt.rawValue, userInfo: userInfo)
    }
}

// swiftlint:enable all
