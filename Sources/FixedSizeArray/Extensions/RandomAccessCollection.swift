extension FixedSizeArray {
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        Self.count
    }
    
    public subscript(index: Int) -> Element {
        get {
            precondition(indices.contains(index), "Index out of range")
            return self[unchecked: index]
        }
        set {
            precondition(indices.contains(index), "Index out of range")
            self[unchecked: index] = newValue
        }
    }
    
    public mutating func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeBufferPointer(body)
    }
    
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
