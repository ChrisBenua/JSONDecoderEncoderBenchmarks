// swiftlint:disable all



internal struct BufferView<Element> {
    let start: BufferViewIndex<Element>
    let count: Int

    private var baseAddress: UnsafeRawPointer { start._rawValue }

    init(_unchecked components: (start: BufferViewIndex<Element>, count: Int)) {
        (self.start, self.count) = components
    }

    init(start index: BufferViewIndex<Element>, count: Int) {
        precondition(
            count >= 0,
            mobs("Count must not be negative"),
            file: "",
            line: 20
        )
        if !_isPOD(Element.self) {
            precondition(
                index.isAligned,
                mobs("baseAddress must be properly aligned for \(Element.self)"),
                file: "",
                line: 27
            )
        }
        self.init(_unchecked: (index, count))
    }

    init(unsafeBaseAddress: UnsafeRawPointer, count: Int) {
        self.init(start: .init(rawValue: unsafeBaseAddress), count: count)
    }

    init?(unsafeBufferPointer buffer: UnsafeBufferPointer<Element>) {
        guard let baseAddress = UnsafeRawPointer(buffer.baseAddress) else { return nil }
        self.init(unsafeBaseAddress: baseAddress, count: buffer.count)
    }
}

extension BufferView {

    // FIXME: mark closure parameter as non-escaping
    func withUnsafePointer<R>(
        _ body: (
            _ pointer: UnsafePointer<Element>,
            _ capacity: Int
        ) throws -> R
    ) rethrows -> R {
        try baseAddress.withMemoryRebound(
            to: Element.self, capacity: count, { try body($0, count) }
        )
    }
}

extension BufferView /* where Element: BitwiseCopyable */ {

    // FIXME: mark closure parameter as non-escaping
    func withUnsafeRawPointer<R>(
        _ body: (_ pointer: UnsafeRawPointer, _ count: Int) throws -> R
    ) rethrows -> R {
        try body(baseAddress, count * MemoryLayout<Element>.stride)
    }
}

extension BufferView<UInt8> {
    internal func slice(from startOffset: Int, count sliceCount: Int) -> BufferView {
        precondition(
            startOffset >= 0 && startOffset < count && sliceCount >= 0
                && sliceCount <= count && startOffset &+ sliceCount <= count
        )
        return uncheckedSlice(from: startOffset, count: sliceCount)
    }

    internal func uncheckedSlice(from startOffset: Int, count sliceCount: Int) -> BufferView {
        let address = startIndex.advanced(by: startOffset)
        return BufferView(start: address, count: sliceCount)
    }

    internal subscript(region: JSONMap.Region) -> BufferView {
        slice(from: region.startOffset, count: region.count)
    }
}

extension BufferView:
    Collection,
    BidirectionalCollection,
    RandomAccessCollection {

    typealias Element = Element
    typealias Index = BufferViewIndex<Element>
    typealias SubSequence = Self

    @inline(__always)
    var startIndex: Index { start }

    @inline(__always)
    var endIndex: Index { start.advanced(by: count) }

    @inline(__always)
    var indices: Range<Index> {
        .init(uncheckedBounds: (startIndex, endIndex))
    }

    @inline(__always)
    func _checkBounds(_ position: Index) {
        precondition(
            distance(from: startIndex, to: position) >= 0
                && distance(from: position, to: endIndex) > 0,
            mobs("Index out of bounds"),
            file: "",
            line: 114
        )
        // FIXME: Use `BitwiseCopyable` layout constraint
        if !_isPOD(Element.self) {
            precondition(
                position.isAligned,
                mobs("Index is unaligned for Element"),
                file: "",
                line: 122
            )
        }
    }

    @inline(__always)
    func _checkBounds(_ bounds: Range<Index>) {
        precondition(
            distance(from: startIndex, to: bounds.lowerBound) >= 0
                && distance(from: bounds.lowerBound, to: bounds.upperBound) >= 0
                && distance(from: bounds.upperBound, to: endIndex) >= 0,
            mobs("Range of indices out of bounds"),
            file: "",
            line: 135
        )
        // FIXME: Use `BitwiseCopyable` layout constraint
        if !_isPOD(Element.self) {
            precondition(
                bounds.lowerBound.isAligned && bounds.upperBound.isAligned,
                mobs("Range of indices is unaligned for Element"),
                file: "",
                line: 143
            )
        }
    }

    @inline(__always)
    func index(after i: Index) -> Index {
        i.advanced(by: +1)
    }

    @inline(__always)
    func index(before i: Index) -> Index {
        i.advanced(by: -1)
    }

    @inline(__always)
    func formIndex(after i: inout Index) {
        i = index(after: i)
    }

    @inline(__always)
    func formIndex(before i: inout Index) {
        i = index(before: i)
    }

    @inline(__always)
    func index(_ i: Index, offsetBy distance: Int) -> Index {
        i.advanced(by: distance)
    }

    @inline(__always)
    func formIndex(_ i: inout Index, offsetBy distance: Int) {
        i = index(i, offsetBy: distance)
    }

    @inline(__always)
    func distance(from start: Index, to end: Index) -> Int {
        start.distance(to: end)
    }

    @inline(__always)
    subscript(position: Index) -> Element {
        _checkBounds(position)
        return self[unchecked: position]
    }

    @inline(__always)
    subscript(unchecked position: Index) -> Element {
        if _isPOD(Element.self) {
            return position._rawValue.loadUnaligned(as: Element.self)
        } else {
            return position._rawValue.load(as: Element.self)
        }
    }

    @inline(__always)
    subscript(bounds: Range<Index>) -> Self {
        _checkBounds(bounds)
        return self[unchecked: bounds]
    }

    @inline(__always)
    subscript(unchecked bounds: Range<Index>) -> Self { BufferView(_unchecked: (bounds.lowerBound, bounds.count)) }
}

// MARK: load and store

extension BufferView /* where Element: BitwiseCopyable */ {

    func loadUnaligned<T /*: BitwiseCopyable */>(
        fromByteOffset offset: Int = 0, as: T.Type
    ) -> T {
        guard _isPOD(Element.self), _isPOD(T.self) else { fatalError() }
        _checkBounds(
            Range(
                uncheckedBounds: (
                    .init(rawValue: baseAddress.advanced(by: offset)),
                    .init(rawValue: baseAddress.advanced(by: offset + MemoryLayout<T>.size))
                )
            )
        )
        return baseAddress.loadUnaligned(fromByteOffset: offset, as: T.self)
    }

    func loadUnaligned<T /*: BitwiseCopyable */>(
        from index: Index, as: T.Type
    ) -> T {
        let o = distance(from: startIndex, to: index) * MemoryLayout<Element>.stride
        return loadUnaligned(fromByteOffset: o, as: T.self)
    }
}

extension BufferView {

    @inline(__always)
    subscript(offset offset: Int) -> Element {
        precondition(offset >= 0 && offset < count)
        return self[uncheckedOffset: offset]
    }

    @inline(__always)
    subscript(uncheckedOffset offset: Int) -> Element {
        self[unchecked: index(startIndex, offsetBy: offset)]
    }
}

// swiftlint:enable all
