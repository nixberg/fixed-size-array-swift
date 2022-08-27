extension FixedSizeArray {
    @inline(__always)
    public var startIndex: Index {
        0
    }
    
    @inline(__always)
    public var endIndex: Index {
        Self.count
    }
    
    @inline(__always)
    public subscript(position: Index) -> Element {
        get {
            precondition(indices.contains(position), "Index out of range")
            return self[unchecked: position]
        }
        set {
            precondition(indices.contains(position), "Index out of range")
            self[unchecked: position] = newValue
        }
    }
    
    @inline(__always)
    public mutating func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeBufferPointer(body)
    }
    
    @inline(__always)
    public mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeMutableBufferPointer {
            let baseAddress = $0.baseAddress
            let count = $0.count
            
            var inoutBufferPointer = UnsafeMutableBufferPointer(
                start: baseAddress,
                count: count
            )
            
            defer {
                precondition(
                    inoutBufferPointer.baseAddress == baseAddress &&
                    inoutBufferPointer.count == count,
                    """
                    \(Self.self) withContiguousMutableStorageIfAvailable: \
                    replacing the buffer is not allowed
                    """
                )
            }
            
            return try body(&inoutBufferPointer)
        }
    }
}
