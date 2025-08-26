

// swiftlint:disable all
struct OutputBuffer<T>: ~Copyable { // ~Escapable
    let start: UnsafeMutablePointer<T>
    let capacity: Int
    var initialized: Int = 0

    deinit {
        // `self` always borrows memory, and it shouldn't have gotten here.
        // Failing to use `relinquishBorrowedMemory()` is an error.
        if initialized > 0 {
            fatalError()
        }
    }

    // precondition: pointer points to uninitialized memory for count elements
    init(initializing: UnsafeMutablePointer<T>, capacity: Int) {
        self.start = initializing
        self.capacity = capacity
    }
}

extension OutputBuffer {
    mutating func appendElement(_ value: T) {
        precondition(
            initialized < capacity,
            mobs("Output buffer overflow"),
            file: "",
            line: 30
        )
        start.advanced(by: initialized).initialize(to: value)
        initialized &+= 1
    }
}

extension OutputBuffer {

    consuming func relinquishBorrowedMemory() -> UnsafeMutableBufferPointer<T> {
        let start = self.start
        let initialized = self.initialized
        discard self
        return .init(start: start, count: initialized)
    }
}

// swiftlint:enable all
