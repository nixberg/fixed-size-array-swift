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
    public subscript(unchecked position: Int) -> Element {
        get {
            self.withUnsafeBufferPointer {
                $0[position]
            }
        }
        set {
            self.withUnsafeMutableBufferPointer {
                $0[position] = newValue
            }
        }
    }
    
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try withUnsafePointer(to: self) {
            try body(UnsafeBufferPointer<Element>(
                start: UnsafeRawPointer($0).assumingMemoryBound(to: Element.self),
                count: Self.count
            ))
        }
    }
    
    public mutating func withUnsafeMutableBufferPointer<R>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try withUnsafeMutablePointer(to: &self) {
            try body(UnsafeMutableBufferPointer<Element>(
                start: UnsafeMutableRawPointer($0).assumingMemoryBound(to: Element.self),
                count: Self.count
            ))
        }
    }
}
