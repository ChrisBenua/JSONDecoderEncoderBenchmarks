import Foundation

// swiftlint:disable all
internal struct BufferViewIndex<Element> {
    let _rawValue: UnsafeRawPointer

    @inline(__always)
    internal init(rawValue: UnsafeRawPointer) {
        self._rawValue = rawValue
    }

    @inline(__always)
    var isAligned: Bool {
        (Int(bitPattern: _rawValue) & (MemoryLayout<Element>.alignment - 1)) == 0
    }
}

extension Data {
    func withBufferView<ResultType>(
        _ body: (BufferView<UInt8>) throws -> ResultType
    ) rethrows -> ResultType {
        try withUnsafeBytes {
            // Data never passes an empty buffer with a `nil` `baseAddress`.
            try body(BufferView(unsafeRawBufferPointer: $0)!)
        }
    }
}

extension BufferView /* where Element: BitwiseCopyable */ {

    init?(unsafeRawBufferPointer buffer: UnsafeRawBufferPointer) {
        guard _isPOD(Element.self) else { fatalError() }
        guard let p = buffer.baseAddress else { return nil }
        let (q, r) = buffer.count.quotientAndRemainder(dividingBy: MemoryLayout<Element>.stride)
        precondition(r == 0)
        self.init(unsafeBaseAddress: p, count: q)
    }
}

extension BufferViewIndex: Equatable {}

extension BufferViewIndex: Hashable {}

extension BufferViewIndex: Strideable {
    typealias Stride = Int

    @inline(__always)
    func distance(to other: BufferViewIndex) -> Int {
        _rawValue.distance(to: other._rawValue) / MemoryLayout<Element>.stride
    }

    @inline(__always)
    func advanced(by n: Int) -> BufferViewIndex {
        .init(rawValue: _rawValue.advanced(by: n &* MemoryLayout<Element>.stride))
    }
}

extension BufferViewIndex: Comparable {
    @inline(__always)
    static func < (lhs: BufferViewIndex, rhs: BufferViewIndex) -> Bool {
        lhs._rawValue < rhs._rawValue
    }
}

@available(*, unavailable)
extension BufferViewIndex: Sendable {}
// swiftlint:enable all
