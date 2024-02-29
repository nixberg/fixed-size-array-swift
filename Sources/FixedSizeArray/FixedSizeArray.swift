public protocol FixedSizeArray<Element>:
    CustomDebugStringConvertible,
    CustomStringConvertible,
    MutableCollection,
    RandomAccessCollection
where Index == Int {
    associatedtype Element
    
    static var count: Int { get }
    
    init(repeating element: Element)
}

// MARK: -

extension FixedSizeArray where Element: AdditiveArithmetic {
    public init(_ sequence: some Sequence<Element>) {
        self.init(repeating: .zero)
        var index = startIndex
        for element in sequence {
            precondition(index != endIndex, "Too many elements in sequence")
            self[index] = element
            index += 1
        }
        precondition(index == endIndex, "Not enough elements in sequence")
    }
}

// MARK: -

extension FixedSizeArray {
    public subscript(unchecked index: Int) -> Element {
        get {
            self.withUnsafeBufferPointer {
                $0[index]
            }
        }
        set {
            self.withUnsafeMutableBufferPointer {
                $0[index] = newValue
            }
        }
    }
    
    public func _withUnprotectedUnsafeBytes<R>(
        _ body: (UnsafeRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift._withUnprotectedUnsafeBytes(of: self, body)
    }
    
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try self.withUnsafeBytes {
            try $0.withMemoryRebound(to: Element.self, body)
        }
    }
    
    public func withUnsafeBytes<R>(
        _ body: (UnsafeRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift.withUnsafeBytes(of: self, body)
    }
    
    public mutating func withUnsafeMutableBufferPointer<R>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try self.withUnsafeMutableBytes {
            try $0.withMemoryRebound(to: Element.self, body)
        }
    }
    
    public mutating func withUnsafeMutableBytes<R>(
        _ body: (UnsafeMutableRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift.withUnsafeMutableBytes(of: &self, body)
    }
}
