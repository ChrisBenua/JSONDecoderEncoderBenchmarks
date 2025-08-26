import Foundation


// swiftlint:disable all
private let powerOfTen: [CustomDecimal.VariableLengthInteger] = [
    /* ^00 */ [0x0001],
    /* ^01 */ [0x000A],
    /* ^02 */ [0x0064],
    /* ^03 */ [0x03E8],
    /* ^04 */ [0x2710],
    /* ^05 */ [0x86A0, 0x0001],
    /* ^06 */ [0x4240, 0x000F],
    /* ^07 */ [0x9680, 0x0098],
    /* ^08 */ [0xE100, 0x05F5],
    /* ^09 */ [0xCA00, 0x3B9A],
    /* ^10 */ [0xE400, 0x540B, 0x0002],
    /* ^11 */ [0xE800, 0x4876, 0x0017],
    /* ^12 */ [0x1000, 0xD4A5, 0x00E8],
    /* ^13 */ [0xA000, 0x4E72, 0x0918],
    /* ^14 */ [0x4000, 0x107A, 0x5AF3],
    /* ^15 */ [0x8000, 0xA4C6, 0x8D7E, 0x0003],
    /* ^16 */ [0x0000, 0x6FC1, 0x86F2, 0x0023],
    /* ^17 */ [0x0000, 0x5D8A, 0x4578, 0x0163],
    /* ^18 */ [0x0000, 0xA764, 0xB6B3, 0x0DE0],
    /* ^19 */ [0x0000, 0x89E8, 0x2304, 0x8AC7],
    /* ^20 */ [0x0000, 0x6310, 0x5E2D, 0x6BC7, 0x0005],
    /* ^21 */ [0x0000, 0xDEA0, 0xADC5, 0x35C9, 0x0036],
    /* ^22 */ [0x0000, 0xB240, 0xC9BA, 0x19E0, 0x021E],
    /* ^23 */ [0x0000, 0xF680, 0xE14A, 0x02C7, 0x152D],
    /* ^24 */ [0x0000, 0xA100, 0xCCED, 0x1BCE, 0xD3C2],
    /* ^25 */ [0x0000, 0x4A00, 0x0148, 0x1614, 0x4595, 0x0008],
    /* ^26 */ [0x0000, 0xE400, 0x0CD2, 0xDCC8, 0xB7D2, 0x0052],
    /* ^27 */ [0x0000, 0xE800, 0x803C, 0x9FD0, 0x2E3C, 0x033B],
    /* ^28 */ [0x0000, 0x1000, 0x0261, 0x3E25, 0xCE5E, 0x204F],
    /* ^29 */ [0x0000, 0xA000, 0x17CA, 0x6D72, 0x0FAE, 0x431E, 0x0001],
    /* ^30 */ [0x0000, 0x4000, 0xEDEA, 0x4674, 0x9CD0, 0x9F2C, 0x000C],
    /* ^31 */ [0x0000, 0x8000, 0x4B26, 0xC091, 0x2022, 0x37BE, 0x007E],
    /* ^32 */ [0x0000, 0x0000, 0xEF81, 0x85AC, 0x415B, 0x2D6D, 0x04EE],
    /* ^33 */ [0x0000, 0x0000, 0x5B0A, 0x38C1, 0x8D93, 0xC644, 0x314D],
    /* ^34 */ [0x0000, 0x0000, 0x8E64, 0x378D, 0x87C0, 0xBEAD, 0xED09, 0x0001],
    /* ^35 */ [0x0000, 0x0000, 0x8FE8, 0x2B87, 0x4D82, 0x72C7, 0x4261, 0x0013],
    /* ^36 */ [0x0000, 0x0000, 0x9F10, 0xB34B, 0x0715, 0x7BC9, 0x97CE, 0x00C0],
    /* ^37 */ [0x0000, 0x0000, 0x36A0, 0x00F4, 0x46D9, 0xD5DA, 0xEE10, 0x0785],
    /* ^38 */ [0x0000, 0x0000, 0x2240, 0x098A, 0xC47A, 0x5A86, 0x4CA8, 0x4B3B]
]

public struct CustomDecimal: Sendable {
    public typealias Mantissa = (UInt16, UInt16, UInt16, UInt16, UInt16, UInt16, UInt16, UInt16)

    internal struct Storage: Sendable {
        var exponent: Int8
        // Layout:
        // |  0  1  2  3 | 4 | 5 | 6  7 |
        // | -> _length  | | | | | ->_reserved
        // |             | | | |-> _isCompact
        // |             | |-> _isNegative
        var lengthFlagsAndReserved: UInt8
        // 18 bits long
        var reserved: UInt16
        var mantissa: Mantissa
    }

    internal var storage: Storage

    // Int8
    internal var _exponent: Int32 {
        get {
            return Int32(storage.exponent)
        }
        set {
            storage.exponent = Int8(newValue)
        }
    }

    // 4 bits
    internal var _length: UInt32 {
        get {
            return UInt32(storage.lengthFlagsAndReserved >> 4)
        }
        set {
            let newLength = (UInt8(truncatingIfNeeded: newValue) & 0x0F) << 4
            storage.lengthFlagsAndReserved &= 0x0F // clear the length
            storage.lengthFlagsAndReserved |= newLength // set the new length
        }
    }

    // Bool
    internal var _isNegative: UInt32 {
        get {
            return UInt32((storage.lengthFlagsAndReserved >> 3) & 0x01)
        }
        set {
            if (newValue & 0x1) != 0 {
                storage.lengthFlagsAndReserved |= 0b0000_1000
            } else {
                storage.lengthFlagsAndReserved &= 0b1111_0111
            }
        }
    }

    // Bool
    internal var _isCompact: UInt32 {
        get {
            return UInt32((storage.lengthFlagsAndReserved >> 2) & 0x01)
        }
        set {
            if (newValue & 0x1) != 0 {
                storage.lengthFlagsAndReserved |= 0b0000_0100
            } else {
                storage.lengthFlagsAndReserved &= 0b1111_1011
            }
        }
    }

    // Only 18 bits
    internal var _reserved: UInt32 {
        get {
            return (UInt32(storage.lengthFlagsAndReserved & 0x03) << 16) | UInt32(storage.reserved)
        }
        set {
            // Bottom 16 bits
            storage.reserved = UInt16(newValue & 0xFFFF)
            storage.lengthFlagsAndReserved &= 0xFC
            storage.lengthFlagsAndReserved |= UInt8(newValue >> 16) & 0xFF
        }
    }

    internal var _mantissa: Mantissa {
        get {
            return storage.mantissa
        }
        set {
            storage.mantissa = newValue
        }
    }

    static let zero = CustomDecimal(_exponent: 0, _length: 0, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (0 as UInt16, 0 as UInt16, 0 as UInt16, 0 as UInt16, 0 as UInt16, 0 as UInt16, 0 as UInt16, 0 as UInt16))

    public init(
        _exponent: Int32 = 0,
        _length: UInt32,
        _isNegative: UInt32 = 0,
        _isCompact: UInt32,
        _reserved: UInt32 = 0,
        _mantissa: Mantissa
    ) {
        let length: UInt8 = (UInt8(truncatingIfNeeded: _length) & 0xF) << 4
        let isNegative: UInt8 = UInt8(truncatingIfNeeded: _isNegative & 0x1) == 0 ? 0 : 0b0000_1000
        let isCompact: UInt8 = UInt8(truncatingIfNeeded: _isCompact & 0x1) == 0 ? 0 : 0b0000_0100
        let reservedLeft: UInt8 = UInt8(truncatingIfNeeded: (_reserved & 0x3FFFF) >> 16)
        self.storage = .init(
            exponent: Int8(truncatingIfNeeded: _exponent),
            lengthFlagsAndReserved: length | isNegative | isCompact | reservedLeft,
            reserved: UInt16(truncatingIfNeeded: _reserved & 0xFFFF),
            mantissa: _mantissa
        )
    }

    public init() {
        self.storage = .init(
            exponent: 0,
            lengthFlagsAndReserved: 0,
            reserved: 0,
            mantissa: (0, 0, 0, 0, 0, 0, 0, 0)
        )
    }
}

extension CustomDecimal {
    public enum RoundingMode: UInt, Sendable {
        case plain
        case down
        case up
        case bankers
    }

    public enum CalculationError: UInt, Sendable {
        case noError
        case lossOfPrecision
        case overflow
        case underflow
        case divideByZero
    }
}

// MARK: - String

extension CustomDecimal {
    var isNaN: Bool { _length == 0 && _isNegative == 1 }

    static var nan: CustomDecimal { quietNaN }

    static var quietNaN: CustomDecimal {
        return CustomDecimal(
            _exponent: 0, _length: 0, _isNegative: 1, _isCompact: 0,
            _reserved: 0, _mantissa: (0, 0, 0, 0, 0, 0, 0, 0)
        )
    }

    internal enum DecimalParseResult {
        case success(CustomDecimal, processedLength: Int)
        case parseFailure
        case overlargeValue

        var asOptional: (result: CustomDecimal?, processedLength: Int) {
            switch self {
            case let .success(decimal, processedLength): (decimal, processedLength: processedLength)
            default: (nil, processedLength: 0)
            }
        }
    }

    @_specialize(where UTF8Collection == String.UTF8View)
    @_specialize(where UTF8Collection == BufferView<UInt8>)
    internal static func _decimal<UTF8Collection: Collection>(
        from utf8View: UTF8Collection,
        decimalSeparator: String.UTF8View = ".".utf8,
        matchEntireString: Bool
    ) -> DecimalParseResult where UTF8Collection.Element == UTF8.CodeUnit {
        func multiplyBy10AndAdd(
            _ decimal: CustomDecimal,
            number: UInt16
        ) throws -> CustomDecimal {
            do {
                var result = try decimal._multiply(byShort: 10)
                result = try result._add(number)
                return result
            } catch {
                throw _CalculationError.overflow
            }
        }

        func skipWhiteSpaces(from index: UTF8Collection.Index) -> UTF8Collection.Index {
            var i = index
            while i != utf8View.endIndex,
                Character(utf8Scalar: utf8View[i]).isWhitespace {
                utf8View.formIndex(after: &i)
            }
            return i
        }

        func stringViewContainsDecimalSeparator(at index: UTF8Collection.Index) -> Bool {
            for indexOffset in 0 ..< decimalSeparator.count {
                let stringIndex = utf8View.index(index, offsetBy: indexOffset)
                let decimalIndex = decimalSeparator.index(
                    decimalSeparator.startIndex,
                    offsetBy: indexOffset
                )
                if utf8View[stringIndex] != decimalSeparator[decimalIndex] {
                    return false
                }
            }
            return true
        }

        var result = CustomDecimal()
        var index = utf8View.startIndex
        index = skipWhiteSpaces(from: index)
        // Get the sign
        if index != utf8View.endIndex,
            utf8View[index] == UInt8._plus ||
            utf8View[index] == UInt8._minus {
            result._isNegative = (utf8View[index] == UInt8._minus) ? 1 : 0
            // Advance over the sign
            utf8View.formIndex(after: &index)
        }
        // Build mantissa
        var tooBigToFit = false

        while index != utf8View.endIndex,
            let digitValue = utf8View[index].digitValue {
            defer {
                utf8View.formIndex(after: &index)
            }
            // Multiply the value by 10 and add the current digit
            func incrementExponent(_ decimal: inout CustomDecimal) {
                // Before incrementing the exponent, we need to check
                // if it's still possible to increment.
                if decimal._exponent == Int8.max {
                    decimal = .nan
                    return
                }
                decimal._exponent += 1
            }

            if tooBigToFit {
                incrementExponent(&result)
                if result.isNaN {
                    return .overlargeValue
                }
                continue
            }
            guard let product = try? result._multiplyBy10AndAdd(
                number: UInt16(digitValue)
            ) else {
                tooBigToFit = true
                incrementExponent(&result)
                if result.isNaN {
                    return .overlargeValue
                }
                continue
            }
            result = product
        }
        // Get the decimal point
        if index < utf8View.endIndex, stringViewContainsDecimalSeparator(at: index) {
            utf8View.formIndex(&index, offsetBy: decimalSeparator.count)
            // Continue to build the mantissa
            while index != utf8View.endIndex,
                let digitValue = utf8View[index].digitValue {
                defer {
                    utf8View.formIndex(after: &index)
                }
                guard !tooBigToFit else {
                    continue
                }
                guard let product = try? result._multiplyBy10AndAdd(
                    number: UInt16(digitValue)
                ) else {
                    tooBigToFit = true
                    continue
                }
                result = product
                // Before decrementing the exponent, we need to check
                // if it's still possible to decrement.
                if result._exponent == Int8.min {
                    return .overlargeValue
                }
                result._exponent -= 1
            }
        }
        // Get the exponent if any
        if index < utf8View.endIndex, utf8View[index] == UInt8._E || utf8View[index] == UInt8._e {
            utf8View.formIndex(after: &index)
            // If there is no content after e, the string is invalid
            guard index != utf8View.endIndex else {
                // Normally we should return .parseFailure
                // However, NSDecimal historically parses any
                // - Invalid strings starting with `e` as 0
                //    - "en" -> 0
                //    - "e" -> 0
                // - Strings ending with `e` but nothing after as valid
                //    - "1234e" -> 1234
                // So let's keep that behavior here as well
                let processedLength = utf8View.distance(from: utf8View.startIndex, to: index)
                return .success(result, processedLength: processedLength)
            }
            var exponentIsNegative = false
            var exponent = 0
            // Get the exponent sign
            if utf8View[index] == UInt8._minus || utf8View[index] == UInt8._plus {
                exponentIsNegative = utf8View[index] == UInt8._minus
                utf8View.formIndex(after: &index)
            }
            // Build the exponent
            while index != utf8View.endIndex,
                let digitValue = utf8View[index].digitValue {
                exponent = 10 * exponent + digitValue
                if exponent > 2 * Int(Int8.max) {
                    // Too big to fit
                    return .overlargeValue
                }
                utf8View.formIndex(after: &index)
            }
            if exponentIsNegative {
                exponent = -exponent
            }
            // Check to see if it will fit into the exponent field
            exponent += Int(result._exponent)
            if exponent > Int8.max || exponent < Int8.min {
                return .overlargeValue
            }
            result._exponent = Int32(exponent)
        }
        // If we are required to match the entire string,
        // "trim" the end whitespaces and check if we are
        // at the end of the string
        if matchEntireString {
            // Trim end spaces
            index = skipWhiteSpaces(from: index)
            guard index == utf8View.endIndex else {
                // Any unprocessed content means the string
                // contains something not valid
                return .parseFailure
            }
        }
        if index == utf8View.startIndex {
            // If we weren't able to process any character
            // the entire string isn't a valid decimal
            return .parseFailure
        }
        result.compact()
        let processedLength = utf8View.distance(from: utf8View.startIndex, to: index)
        // if we get to this point, and have NaN,
        // then the input string was probably "-0"
        // or some variation on that, and
        // normalize that to zero.
        if result.isNaN {
            return .success(CustomDecimal.zero, processedLength: processedLength)
        }
        return .success(result, processedLength: processedLength)
    }

    // MATH:

    typealias VariableLengthInteger = [UInt16]
    internal static let maxSize: UInt32 = 8

    internal enum _CalculationError: Error {
        case overflow
        case underflow
        case divideByZero
    }

    internal func _multiplyBy10AndAdd(
        number: UInt16
    ) throws -> CustomDecimal {
        do {
            var result = try _multiply(byShort: 10)
            result = try result._add(number)
            return result
        } catch {
            throw _CalculationError.overflow
        }
    }

    private func asVariableLengthInteger() -> VariableLengthInteger {
        switch _mantissa {
        case (0, 0, 0, 0, 0, 0, 0, 0):
            return []
        case let (a0, 0, 0, 0, 0, 0, 0, 0):
            return [a0]
        case let (a0, a1, 0, 0, 0, 0, 0, 0):
            return [a0, a1]
        case let (a0, a1, a2, 0, 0, 0, 0, 0):
            return [a0, a1, a2]
        case let (a0, a1, a2, a3, 0, 0, 0, 0):
            return [a0, a1, a2, a3]
        case let (a0, a1, a2, a3, a4, 0, 0, 0):
            return [a0, a1, a2, a3, a4]
        case let (a0, a1, a2, a3, a4, a5, 0, 0):
            return [a0, a1, a2, a3, a4, a5]
        case let (a0, a1, a2, a3, a4, a5, a6, 0):
            return [a0, a1, a2, a3, a4, a5, a6]
        case let (a0, a1, a2, a3, a4, a5, a6, a7):
            return [a0, a1, a2, a3, a4, a5, a6, a7]
        }
    }

    internal func _divide(by divisor: UInt16) throws -> (result: CustomDecimal, remainder: UInt16) {
        let (resultValue, remainder) = try Self._integerDivideByShort(
            asVariableLengthInteger(), UInt32(divisor)
        )
        var result = self
        try result.copyVariableLengthInteger(resultValue)
        result._length = UInt32(resultValue.count)
        return (result: result, remainder: UInt16(remainder))
    }

    internal mutating func copyVariableLengthInteger(_ source: VariableLengthInteger) throws {
        guard source.count <= CustomDecimal.maxSize else {
            throw _CalculationError.overflow
        }
        _length = UInt32(source.count)
        switch source.count {
        case 0:
            _mantissa = (0, 0, 0, 0, 0, 0, 0, 0)
        case 1:
            _mantissa = (source[0], 0, 0, 0, 0, 0, 0, 0)
        case 2:
            _mantissa = (source[0], source[1], 0, 0, 0, 0, 0, 0)
        case 3:
            _mantissa = (source[0], source[1], source[2], 0, 0, 0, 0, 0)
        case 4:
            _mantissa = (source[0], source[1], source[2], source[3], 0, 0, 0, 0)
        case 5:
            _mantissa = (source[0], source[1], source[2], source[3], source[4], 0, 0, 0)
        case 6:
            _mantissa = (source[0], source[1], source[2], source[3], source[4], source[5], 0, 0)
        case 7:
            _mantissa = (source[0], source[1], source[2], source[3], source[4], source[5], source[6], 0)
        case 8:
            _mantissa = (source[0], source[1], source[2], source[3], source[4], source[5], source[6], source[7])
        default:
            throw _CalculationError.overflow
        }
    }

    private static func _integerDivideByShort(
        _ dividend: VariableLengthInteger,
        _ divisor: UInt32
    ) throws -> (quotient: VariableLengthInteger, remainder: UInt32) {
        if divisor == 0 {
            throw _CalculationError.divideByZero
        }
        var carry: UInt32 = 0
        var acc: UInt32 = 0
        var result: VariableLengthInteger = Array(repeating: 0, count: dividend.count)
        for index in (0 ..< dividend.count).reversed() {
            acc = (UInt32(dividend[index]) + carry * (1 << 16))
            result[index] = UInt16(acc / divisor)
            carry = acc % divisor
        }
        while result.last == 0 {
            result.removeLast()
        }
        return (quotient: result, remainder: carry)
    }

    internal func _multiply(byShort multiplicand: UInt16) throws -> CustomDecimal {
        var result = self
        if multiplicand == 0 {
            result._length = 0
            return result
        }
        var carry: UInt32 = 0
        var index: UInt32 = 0
        while index < result._length {
            let acc = UInt32(result[index]) *
                UInt32(multiplicand) + carry
            carry = acc >> 16
            result[index] = UInt16(acc & 0xFFFF)
            index += 1
        }
        if carry != 0 {
            if result._length >= CustomDecimal.maxSize {
                throw _CalculationError.overflow
            }
            result[index] = UInt16(carry)
            index += 1
        }
        result._length = index
        return result
    }

    internal var doubleValue: Double {
        if _length == 0 {
            return _isNegative == 1 ? Double.nan : 0
        }

        var d = 0.0
        for idx in (0 ..< min(_length, 8)).reversed() {
            d = d * 65536 + Double(self[idx])
        }

        if _exponent < 0 {
            for _ in _exponent ..< 0 {
                d /= 10.0
            }
        } else {
            for _ in 0 ..< _exponent {
                d *= 10.0
            }
        }
        return _isNegative != 0 ? -d : d
    }

    internal func _add(_ amount: UInt16) throws -> CustomDecimal {
        var result = self
        var carry: UInt32 = UInt32(amount)
        var index: UInt32 = 0
        while index < result._length {
            let acc = UInt32(result[index]) + carry
            carry = acc >> 16
            result[index] = UInt16(acc & 0xFFFF)
            index += 1
        }
        if carry != 0 {
            if result._length >= CustomDecimal.maxSize {
                throw _CalculationError.overflow
            }
            result[index] = UInt16(carry)
            index += 1
        }
        result._length = index
        return result
    }

    private static func _integerAddShort(_ lhs: VariableLengthInteger, rhs: UInt32, maxResultLength: Int? = nil) throws -> VariableLengthInteger {
        var carry: UInt32 = rhs
        var result: VariableLengthInteger = Array(repeating: 0, count: lhs.count)
        for index in 0 ..< lhs.count {
            let acc = UInt32(lhs[index]) + carry
            carry = acc >> 16
            result[index] = UInt16(acc & 0xFFFF)
        }
        if carry != 0 {
            if let maxResultLength = maxResultLength, result.count == maxResultLength {
                throw _CalculationError.overflow
            }
            result.append(UInt16(carry))
        }
        return result
    }

    internal static func _compare(lhs: CustomDecimal, rhs: CustomDecimal) -> ComparisonResult {
        if lhs.isNaN {
            if rhs.isNaN {
                return .orderedSame
            }
            return .orderedAscending
        }
        if rhs.isNaN {
            return .orderedDescending
        }
        // Check the sign
        if lhs._isNegative > rhs._isNegative {
            return .orderedAscending
        }
        if lhs._isNegative < rhs._isNegative {
            return .orderedDescending
        }
        // If one of the two is 0, the other is bigger
        // because 0 implies isNegaitive = 0
        if lhs._length == 0 {
            return rhs._length != 0 ? .orderedAscending : .orderedSame
        }
        if rhs._length == 0 {
            return lhs._length != 0 ? .orderedDescending : .orderedSame
        }

        var a = lhs
        var b = rhs
        _ = try? _normalize(a: &a, b: &b, roundingMode: .down)
        // Same exponent now, we can compare the two mantissa
        let result = _integerCompare(
            lhs: a.asVariableLengthInteger(),
            rhs: b.asVariableLengthInteger()
        )
        if a._isNegative != 0 {
            switch result {
            case .orderedSame:
                return result
            case .orderedAscending:
                return .orderedDescending
            case .orderedDescending:
                return .orderedAscending
            }
        }
        return result
    }

    internal static func _normalize(a: inout CustomDecimal, b: inout CustomDecimal, roundingMode: RoundingMode) throws -> Bool {
        var diffExp = Int(a._exponent - b._exponent)
        // If the two numbers share the same exponents,
        // the normalization is already done
        if diffExp == 0 {
            return false
        }

        return try withUnsafeMutablePointer(to: &a) { aPtr -> Bool in
            try withUnsafeMutablePointer(to: &b) { bPtr -> Bool in
                // Put the smaller number in aa
                let aa: UnsafeMutablePointer<CustomDecimal>
                let bb: UnsafeMutablePointer<CustomDecimal>
                if diffExp < 0 {
                    aa = bPtr
                    bb = aPtr
                    diffExp = -diffExp
                } else {
                    aa = aPtr
                    bb = bPtr
                }
                // Try to multiply aa to reach the same exponent level as bb
                let multiplyResult = try? self._integerMultiplyByPowerOfTen(
                    lhs: aa.pointee.asVariableLengthInteger(),
                    power: diffExp,
                    maxResultLength: Int(CustomDecimal.maxSize)
                )
                if let multiplyResult = multiplyResult {
                    // Success! Adjust the length/exponent info
                    try aa.pointee.copyVariableLengthInteger(multiplyResult)
                    aa.pointee._length = UInt32(multiplyResult.count)
                    aa.pointee._exponent = bb.pointee._exponent
                    aa.pointee._isCompact = 0
                    return false
                }
                // What is the maximum pow10 we can apply to aa?
                let maxPowerTen = self._integerMaxPowerOfTenMultiplier(
                    number: aa.pointee.asVariableLengthInteger(),
                    maxResultLength: Int(CustomDecimal.maxSize)
                )
                // Divide bb by this value
                let divideResult = try self._integerMultiplyByPowerOfTen(
                    lhs: bb.pointee.asVariableLengthInteger(),
                    power: maxPowerTen - diffExp,
                    maxResultLength: Int(CustomDecimal.maxSize)
                )
                try bb.pointee.copyVariableLengthInteger(divideResult)
                bb.pointee._length = UInt32(Int32(divideResult.count))
                bb.pointee._exponent -= Int32(maxPowerTen - diffExp)
                bb.pointee._isCompact = 0
                // If bb > 0 multiply aa by the same value
                if bb.pointee._length != 0 {
                    let aaResult = try self._integerMultiplyByPowerOfTen(
                        lhs: aa.pointee.asVariableLengthInteger(),
                        power: maxPowerTen,
                        maxResultLength: Int(CustomDecimal.maxSize)
                    )
                    try aa.pointee.copyVariableLengthInteger(aaResult)
                    aa.pointee._length = UInt32(aaResult.count)
                    aa.pointee._exponent -= Int32(maxPowerTen)
                    aa.pointee._isCompact = 0
                } else {
                    bb.pointee._exponent = aa.pointee._exponent
                }

                // Now the two exponents are identical, but we've lost
                // some digits in the operation
                return true
            }
        }
    }

    private static func _integerMaxPowerOfTenMultiplier(
        number: VariableLengthInteger,
        maxResultLength: Int
    ) -> Int {
        let lengthDiff = maxResultLength - number.count
        // 4.8 ~= log-base-10(2^16)
        let trialValue = (Double(lengthDiff) * 4.81647993)
        return Int(trialValue)
    }

    private static func _integerMultiply(
        lhs: VariableLengthInteger,
        rhs: VariableLengthInteger,
        maxResultLength: Int
    ) throws -> VariableLengthInteger {
        if lhs.isEmpty || rhs.isEmpty {
            return []
        }
        var resultLength = maxResultLength
        if resultLength > lhs.count + rhs.count {
            resultLength = lhs.count + rhs.count
        }
        var result: VariableLengthInteger = Array(repeating: 0, count: resultLength)
        var carry: UInt32 = 0
        for j in 0 ..< rhs.count {
            carry = 0
            for i in 0 ..< lhs.count {
                if i + j < resultLength {
                    let acc = carry + UInt32(result[j + i]) + UInt32(rhs[j]) * UInt32(lhs[i])
                    carry = acc >> 16
                    // FIXME: Check if truncate is okay here
                    result[j + i] = UInt16(truncatingIfNeeded: acc) & 0xFFFF
                } else if carry != 0 || (rhs[j] > 0 && lhs[i] > 0) {
                    throw _CalculationError.overflow
                }
            }

            if carry != 0 {
                if lhs.count + j < resultLength {
                    result[lhs.count + j] = UInt16(carry)
                } else {
                    throw _CalculationError.overflow
                }
            }
        }
        while result.last == 0 {
            result.removeLast()
        }
        return result
    }

    private static func _integerMultiplyByShort(
        lhs: VariableLengthInteger,
        mulplicand: UInt32, maxResultLength: Int
    ) throws -> VariableLengthInteger {
        if mulplicand == 0 {
            return []
        }
        if maxResultLength < lhs.count {
            throw _CalculationError.overflow
        }
        var result: VariableLengthInteger = Array(
            repeating: 0, count: lhs.count
        )
        var carry: UInt32 = 0
        for index in 0 ..< lhs.count {
            let acc = UInt32(lhs[index]) * mulplicand + carry
            carry = acc >> 16
            result[index] = UInt16(acc & 0xFFFF)
        }
        if carry != 0 {
            if maxResultLength == lhs.count {
                throw _CalculationError.overflow
            }
            result.append(UInt16(carry))
        }
        return result
    }

    private static func _integerDivide(
        dividend: VariableLengthInteger,
        divisor: VariableLengthInteger,
        maxResultLength: Int
    ) throws -> VariableLengthInteger {
        if divisor.isEmpty {
            throw _CalculationError.divideByZero
        }
        // If dividend < divisor, the result is appromixtly 0
        if _integerCompare(lhs: dividend, rhs: divisor) == .orderedAscending {
            return [] // zero
        }
        // Fast algorithm
        if divisor.count == 1 {
            return try _integerDivideByShort(
                dividend, UInt32(divisor[0])
            ).quotient
        }

        // D1: Normalize
        // Calculate d such that `d*highest_dight_of_divisor >= b/2 (0x8000)
        let d: UInt32 = (1 << 16) / (UInt32(divisor[divisor.count - 1]) + 1)
        // This is to make the whole algorithm work and
        // (dividend * d) / (divisor * d) == dividend / divisor
        var normalizedDividend = try _integerMultiplyByShort(
            lhs: dividend,
            mulplicand: d,
            maxResultLength: dividend.count + 1
        )
        var normalizedDivisor = try _integerMultiplyByShort(
            lhs: divisor,
            mulplicand: d,
            maxResultLength: divisor.count + 1
        )
        // Set a zero at the leftmost dividend position if the
        // multiplication do not have a carry
        if normalizedDividend.count == dividend.count {
            normalizedDividend.append(0)
        }
        let dividendLength = normalizedDividend.count
        // Set a zero at the leftmost divisor position.
        // The algorithm will use it during the multiplication/
        // subtraction phase
        let divivisorLength = normalizedDivisor.count
        // Intentionally appened after `divivisorLength` has been captured
        normalizedDivisor.append(0)
        // Determine the approxmite size of the quotient
        let quotientLength = normalizedDividend.count - divivisorLength
        // Some useful constant for the loop
        let v1: UInt32 = UInt32(normalizedDivisor[divivisorLength - 1])
        let v2: UInt32 = divivisorLength > 1 ? UInt32(normalizedDivisor[divivisorLength - 2]) : 0

        var result: VariableLengthInteger = Array(repeating: 0, count: maxResultLength)
        // D2: Initialize j
        // On each pass, build a single value for the quotient
        for j in 0 ..< quotientLength {
            // D3: calculate q^
            let tmp: UInt32 = (UInt32(normalizedDividend[dividendLength - j - 1]) << 16) + UInt32(normalizedDividend[dividendLength - j - 2])
            var tmpRemainder = UInt32(tmp % v1)
            var q: UInt32 = tmp / v1

            // This test catches all cases where q is really q+2 and
            // most where it is q+1
            if (q == (1 << 16)) ||
                (v2 * q > (tmpRemainder << 16) + UInt32(normalizedDividend[dividendLength - j - 3])) {
                q -= 1
                tmpRemainder += v1

                if tmpRemainder < (1 << 16),
                    (q == (1 << 16)) ||
                    (v2 * q > (tmpRemainder << 16) + UInt32(normalizedDividend[dividendLength - j - 3])) {
                    q -= 1
                }
            }
            // D4: multiply and subtract
            var multiplyCarry: UInt32 = 0
            var subtractCarry: UInt32 = 1
            for i in 0 ..< divivisorLength + 1 {
                // Multiply
                var acc = q * UInt32(normalizedDivisor[i]) + multiplyCarry
                multiplyCarry = acc >> 16
                acc = acc & 0xFFFF
                // Subtract
                acc = 0xFFFF + UInt32(normalizedDividend[dividendLength - divivisorLength + i - j - 1]) - acc + subtractCarry
                subtractCarry = acc >> 16
                normalizedDividend[dividendLength - divivisorLength + i - j - 1] = UInt16(acc & 0xFFFF)
            }

            // D5: Test remainder
            // This test catches cases where q is still q + 1
            if subtractCarry == 0 {
                // D6: Add back
                var additionCarry: UInt32 = 0
                // Subtract one from quotient digit
                q -= 1
                for i in 0 ..< divivisorLength {
                    let acc = UInt32(normalizedDivisor[i]) + UInt32(normalizedDividend[dividendLength - divivisorLength + i - j - 1]) + additionCarry
                    additionCarry = acc >> 16
                    normalizedDividend[dividendLength - divivisorLength + i - j - 1] = UInt16(acc & 0xFFFF)
                }
            }
            result[quotientLength - j - 1] = UInt16(q)
            // D7: Loop on j
        }
        // Remove extra zeros
        while result.last == 0 {
            result.removeLast()
        }

        return result
    }

    private static func _integerMultiplyByPowerOfTen(
        lhs: VariableLengthInteger,
        power: Int,
        maxResultLength: Int
    ) throws -> VariableLengthInteger {
        // 10^0 == 1, it's just a copy
        if power == 0 {
            return lhs
        }
        var result = lhs
        let isNegative = power < 0
        var powerValue = abs(power)
        let maxPowerTen = powerOfTen.count - 1
        // Handle powers above maxPowerTen
        while powerValue > maxPowerTen {
            powerValue -= maxPowerTen
            let p10 = powerOfTen[maxPowerTen]
            if !isNegative {
                result = try _integerMultiply(
                    lhs: result,
                    rhs: p10,
                    maxResultLength: maxResultLength
                )
            } else {
                result = try _integerDivide(
                    dividend: result,
                    divisor: p10,
                    maxResultLength: maxResultLength
                )
            }
        }
        // Handle reset of the power (<= max)
        let p10 = powerOfTen[powerValue]
        if !isNegative {
            result = try _integerMultiply(
                lhs: result,
                rhs: p10,
                maxResultLength: maxResultLength
            )
        } else {
            result = try _integerDivide(
                dividend: result,
                divisor: p10,
                maxResultLength: maxResultLength
            )
        }
        return result
    }

    private static func _integerCompare(lhs: VariableLengthInteger, rhs: VariableLengthInteger) -> ComparisonResult {
        if lhs.count > rhs.count {
            return .orderedDescending
        }
        if lhs.count < rhs.count {
            return .orderedAscending
        }

        for index in (1 ..< lhs.count + 1).reversed() {
            let left = lhs[index - 1]
            let right = rhs[index - 1]
            if left > right {
                return .orderedDescending
            }
            if left < right {
                return .orderedAscending
            }
        }
        return .orderedSame
    }

    internal mutating func compact() {
        var secureExponent = _exponent
        if _isCompact != 0 || isNaN || _length == 0 {
            // No need to compact
            return
        }
        // Divide by 10 as much as possible
        var remainder: UInt16 = 0
        repeat {
            // divide only throws divieByZero error, which we are not doing here
            let (result, _remainder) = try! _divide(by: 10)
            remainder = _remainder
            self = result
            secureExponent += 1
        } while remainder == 0 && _length > 0
        if _length == 0, remainder == 0 {
            self = CustomDecimal()
            return
        }

        // Put the non-null remdr in place
        self = try! _multiply(byShort: 10)
        self = try! _add(remainder)
        secureExponent -= 1

        // Set the new exponent
        while secureExponent > Int8.max {
            self = try! _multiply(byShort: 10)
            secureExponent -= 1
        }
        _exponent = secureExponent
        // Mark the decimal as compact
        _isCompact = 1
    }
}

private extension Character {
    init(utf8Scalar: UTF8.CodeUnit) {
        self.init(Unicode.Scalar(utf8Scalar))
    }
}

extension CustomDecimal: Hashable {
    internal subscript(index: UInt32) -> UInt16 {
        get {
            switch index {
            case 0: return _mantissa.0
            case 1: return _mantissa.1
            case 2: return _mantissa.2
            case 3: return _mantissa.3
            case 4: return _mantissa.4
            case 5: return _mantissa.5
            case 6: return _mantissa.6
            case 7: return _mantissa.7
            default: fatalError(
                mobs("Invalid index \(index) for _mantissa"),
                file: "",
                line: 1032
            )
            }
        }
        set {
            switch index {
            case 0: _mantissa.0 = newValue
            case 1: _mantissa.1 = newValue
            case 2: _mantissa.2 = newValue
            case 3: _mantissa.3 = newValue
            case 4: _mantissa.4 = newValue
            case 5: _mantissa.5 = newValue
            case 6: _mantissa.6 = newValue
            case 7: _mantissa.7 = newValue
            default: fatalError(
                mobs("Invalid index \(index) for _mantissa"),
                file: "",
                line: 1049
            )
            }
        }
    }

    public func hash(into hasher: inout Hasher) {
        // FIXME: This is a weak hash.  We should rather normalize self to a
        // canonical member of the exact same equivalence relation that
        // NSDecimalCompare implements, then simply feed all components to the
        // hasher.
        hasher.combine(doubleValue)
    }

    public static func == (lhs: CustomDecimal, rhs: CustomDecimal) -> Bool {
        let bitwiseEqual: Bool =
            lhs._exponent == rhs._exponent &&
            lhs._length == rhs._length &&
            lhs._isNegative == rhs._isNegative &&
            lhs._isCompact == rhs._isCompact &&
            lhs._reserved == rhs._reserved &&
            lhs._mantissa.0 == rhs._mantissa.0 &&
            lhs._mantissa.1 == rhs._mantissa.1 &&
            lhs._mantissa.2 == rhs._mantissa.2 &&
            lhs._mantissa.3 == rhs._mantissa.3 &&
            lhs._mantissa.4 == rhs._mantissa.4 &&
            lhs._mantissa.5 == rhs._mantissa.5 &&
            lhs._mantissa.6 == rhs._mantissa.6 &&
            lhs._mantissa.7 == rhs._mantissa.7

        if bitwiseEqual {
            return true
        }
        return CustomDecimal._compare(lhs: lhs, rhs: rhs) == .orderedSame
    }
}

enum ComparisonResult: Int, Sendable {
    case orderedAscending = -1
    case orderedSame = 0
    case orderedDescending = 1
}

// swiftlint:enable all
