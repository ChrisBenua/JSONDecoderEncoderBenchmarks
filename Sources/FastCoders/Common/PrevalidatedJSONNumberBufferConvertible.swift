import Foundation

// swiftlint:disable all
protocol PrevalidatedJSONNumberBufferConvertible {
    init?(prevalidatedBuffer buffer: BufferView<UInt8>)
}

extension Double: PrevalidatedJSONNumberBufferConvertible {
    init?(prevalidatedBuffer buffer: BufferView<UInt8>) {
        let decodedValue = buffer.withUnsafePointer { nptr, count -> Double? in
            var endPtr: UnsafeMutablePointer<CChar>?
            let decodedValue = strtod_l(nptr, &endPtr, nil)
            if let endPtr, nptr.advanced(by: count) == endPtr {
                return decodedValue
            } else {
                return nil
            }
        }
        guard let decodedValue else { return nil }
        self = decodedValue
    }
}

extension Float: PrevalidatedJSONNumberBufferConvertible {
    init?(prevalidatedBuffer buffer: BufferView<UInt8>) {
        let decodedValue = buffer.withUnsafePointer { nptr, count -> Float? in
            var endPtr: UnsafeMutablePointer<CChar>?
            let decodedValue = strtof_l(nptr, &endPtr, nil)
            if let endPtr, nptr.advanced(by: count) == endPtr {
                return decodedValue
            } else {
                return nil
            }
        }
        guard let decodedValue else { return nil }
        self = decodedValue
    }
}

// swiftlint:enable all
