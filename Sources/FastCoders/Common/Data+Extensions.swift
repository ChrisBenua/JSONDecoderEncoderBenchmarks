// swiftlint:disable all

import Foundation

extension Data {
    init?(decodingBase64 bytes: borrowing BufferView<UInt8>, options: Base64DecodingOptions = []) {
        guard bytes.count.isMultiple(of: 4) || options.contains(.ignoreUnknownCharacters)
        else { return nil }

        // Every 4 valid ASCII bytes maps to 3 output bytes: (bytes.count * 3)/4
        let capacity = (bytes.count * 3) >> 2
        // A non-trapping version of the calculation goes like this:
        // let (q, r) = bytes.count.quotientAndRemainder(dividingBy: 4)
        // let capacity = (q * 3) + (r==0 ? 0 : r-1)
        let decoded = try? Data(
            capacity: capacity,
            initializingWith: { // FIXME: should work with borrowed `bytes`
                [bytes = copy bytes] in
                try Data.base64DecodeBytes(bytes, &$0, options: options)
            }
        )
        guard let decoded else { return nil }
        self = decoded
    }

    static func base64DecodeBytes(
        _ bytes: BufferView<UInt8>, _ output: inout OutputBuffer<UInt8>, options: Base64DecodingOptions = []
    ) throws {
        guard bytes.count.isMultiple(of: 4) || options.contains(.ignoreUnknownCharacters)
        else { throw Base64Error.invalidElementCount }

        // This table maps byte values 0-127, input bytes >127 are always invalid.
        // Map the ASCII characters "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" -> 0...63
        // Map '=' (ASCII 61) to 0x40.
        // All other values map to 0x7f. This allows '=' and invalid bytes to be checked together by testing bit 6 (0x40).
        let base64Decode: StaticString = """
        \u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\
        \u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\
        \u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\u{3e}\u{7f}\u{7f}\u{7f}\u{3f}\
        \u{34}\u{35}\u{36}\u{37}\u{38}\u{39}\u{3a}\u{3b}\u{3c}\u{3d}\u{7f}\u{7f}\u{7f}\u{40}\u{7f}\u{7f}\
        \u{7f}\u{00}\u{01}\u{02}\u{03}\u{04}\u{05}\u{06}\u{07}\u{08}\u{09}\u{0a}\u{0b}\u{0c}\u{0d}\u{0e}\
        \u{0f}\u{10}\u{11}\u{12}\u{13}\u{14}\u{15}\u{16}\u{17}\u{18}\u{19}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}\
        \u{7f}\u{1a}\u{1b}\u{1c}\u{1d}\u{1e}\u{1f}\u{20}\u{21}\u{22}\u{23}\u{24}\u{25}\u{26}\u{27}\u{28}\
        \u{29}\u{2a}\u{2b}\u{2c}\u{2d}\u{2e}\u{2f}\u{30}\u{31}\u{32}\u{33}\u{7f}\u{7f}\u{7f}\u{7f}\u{7f}
        """
        assert(base64Decode.isASCII)
        assert(base64Decode.utf8CodeUnitCount == 128)
        assert(base64Decode.hasPointerRepresentation)

        let ignoreUnknown = options.contains(.ignoreUnknownCharacters)

        var currentByte: UInt8 = 0
        var validCharacterCount = 0
        var paddingCount = 0
        var index = 0

        for base64Char in bytes {
            var value: UInt8 = 0

            var invalid = false
            if base64Char >= base64Decode.utf8CodeUnitCount {
                invalid = true
            } else {
                value = base64Decode.utf8Start[Int(base64Char)]
                if value & 0x40 == 0x40 { // Input byte is either '=' or an invalid value.
                    if value == 0x7F {
                        invalid = true
                    } else if value == 0x40 { // '=' padding at end of input.
                        paddingCount += 1
                        continue
                    }
                }
            }

            if invalid {
                if ignoreUnknown {
                    continue
                } else {
                    throw Base64Error.cannotDecode
                }
            }
            validCharacterCount += 1

            // Padding found in the middle of the sequence is invalid.
            if paddingCount > 0 {
                throw Base64Error.cannotDecode
            }

            switch index {
            case 0:
                currentByte = (value << 2)
            case 1:
                currentByte |= (value >> 4)
                output.appendElement(currentByte)
                currentByte = (value << 4)
            case 2:
                currentByte |= (value >> 2)
                output.appendElement(currentByte)
                currentByte = (value << 6)
            case 3:
                currentByte |= value
                output.appendElement(currentByte)
                index = -1
            default:
                fatalError("Invalid state")
            }

            index += 1
        }

        guard (validCharacterCount + paddingCount) % 4 == 0 else {
            // Invalid character count of valid input characters.
            throw Base64Error.cannotDecode
        }
    }
}

private enum Base64Error: Error {
    case invalidElementCount
    case cannotDecode
}

extension Data {

    init(
        capacity: Int,
        initializingWith initializer: (inout OutputBuffer<UInt8>) throws -> Void
    ) rethrows {
        self = Data(count: capacity) // initialized with zeroed buffer
        let count = try withUnsafeMutableBytes { rawBuffer in
            try rawBuffer.withMemoryRebound(to: UInt8.self) { buffer in
                buffer.deinitialize()
                var output = OutputBuffer(
                    initializing: buffer.baseAddress.unsafelyUnwrapped,
                    capacity: capacity
                )
                do {
                    try initializer(&output)
                    let initialized = output.relinquishBorrowedMemory()
                    assert(initialized.baseAddress == buffer.baseAddress)
                    buffer[initialized.count ..< buffer.count].initialize(repeating: 0)
                    return initialized.count
                } catch {
                    // Do this regardless of outcome
                    _ = output.relinquishBorrowedMemory()
                    throw error
                }
            }
        }
        assert(
            count <= self.count,
            file: "",
            line: 153
        )
        replaceSubrange(count ..< self.count, with: EmptyCollection())
    }
}

// swiftlint:enable all
