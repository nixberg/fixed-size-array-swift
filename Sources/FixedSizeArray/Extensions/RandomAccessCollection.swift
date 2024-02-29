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
        _ body: (inout UnsafeMutableBufferPointer<Self.Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeMutableBufferPointer { bufferPointer in
            var inoutBufferPointer = bufferPointer
            defer {
                precondition(
                    inoutBufferPointer == bufferPointer,
                    "\(Self.self) \(#function): replacing the buffer is not allowed"
                )
            }
            return try body(&inoutBufferPointer)
        }
    }
}

extension UnsafeMutableBufferPointer {
    fileprivate static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.baseAddress == rhs.baseAddress && lhs.count == rhs.count
    }
}
