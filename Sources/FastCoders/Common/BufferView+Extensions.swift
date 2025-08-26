// swiftlint:disable all
extension String {
    static func _tryFromUTF8(_ input: BufferView<UInt8>) -> String? {
        input.withUnsafePointer { pointer, capacity in
            _tryFromUTF8(.init(start: pointer, count: capacity))
        }
    }
}

extension FixedWidthInteger {
    init?(prevalidatedBuffer buffer: BufferView<UInt8>) {
        guard let val: Self = _parseInteger(buffer) else {
            return nil
        }
        self = val
    }
}

internal func _parseInteger<Result: FixedWidthInteger>(_ codeUnits: BufferView<UInt8>) -> Result? {
    guard _fastPath(!codeUnits.isEmpty) else { return nil }

    // ASCII constants, named for clarity:
    let _plus = 43 as UInt8, _minus = 45 as UInt8

    let first = codeUnits[uncheckedOffset: 0]
    if first == _minus {
        return _parseIntegerDigits(codeUnits.dropFirst(), isNegative: true)
    }
    if first == _plus {
        return _parseIntegerDigits(codeUnits.dropFirst(), isNegative: false)
    }
    return _parseIntegerDigits(codeUnits, isNegative: false)
}

internal
func _parseIntegerDigits<Result: FixedWidthInteger>(
    _ codeUnits: BufferView<UInt8>, isNegative: Bool
) -> Result? {
    guard _fastPath(!codeUnits.isEmpty) else { return nil }

    // ASCII constants, named for clarity:
    let _0 = 48 as UInt8

    let numericalUpperBound: UInt8 = _0 &+ 10
    let multiplicand: Result = 10
    var result: Result = 0

    var iter = codeUnits.makeIterator()
    while let digit = iter.next() {
        let digitValue: Result
        if _fastPath(digit >= _0 && digit < numericalUpperBound) {
            digitValue = Result(truncatingIfNeeded: digit &- _0)
        } else {
            return nil
        }
        let overflow1: Bool
        (result, overflow1) = result.multipliedReportingOverflow(by: multiplicand)
        let overflow2: Bool
        (result, overflow2) = isNegative
            ? result.subtractingReportingOverflow(digitValue)
            : result.addingReportingOverflow(digitValue)
        guard _fastPath(!overflow1 && !overflow2) else { return nil }
    }
    return result
}

extension FixedWidthInteger {
    init?(prevalidatedJSON5Buffer buffer: BufferView<UInt8>, isHex: Bool) {
        guard let val: Self = _parseJSON5Integer(buffer, isHex: isHex) else {
            return nil
        }
        self = val
    }
}

internal func _parseJSON5Integer<Result: FixedWidthInteger>(
    _ codeUnits: BufferView<UInt8>, isHex: Bool
) -> Result? {
    guard _fastPath(!codeUnits.isEmpty) else { return nil }

    // ASCII constants, named for clarity:
    let _plus = 43 as UInt8, _minus = 45 as UInt8

    var isNegative = false
    var digitsToParse = codeUnits
    switch codeUnits[uncheckedOffset: 0] {
    case _minus:
        isNegative = true
        fallthrough
    case _plus:
        digitsToParse = digitsToParse.dropFirst(1)
    default:
        break
    }

    // Trust the caller regarding whether this is valid hex data.
    if isHex {
        digitsToParse = digitsToParse.dropFirst(2)
        return _parseHexIntegerDigits(digitsToParse, isNegative: isNegative)
    } else {
        return _parseIntegerDigits(digitsToParse, isNegative: isNegative)
    }
}

// swiftlint:enable all
