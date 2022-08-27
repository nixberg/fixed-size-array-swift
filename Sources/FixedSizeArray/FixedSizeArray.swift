public protocol FixedSizeArray<Element>:
    CustomDebugStringConvertible,
    CustomReflectable,
    CustomStringConvertible,
    MutableCollection,
    RandomAccessCollection
where Index == Int {
    static var startIndex: Index { get }
    
    static var endIndex: Index { get }
    
    static var indices: Range<Index> { get }
    
    static var count: Int { get }
    
    init(repeating element: Element)
    
    var first: Element { get set }
    
    var last: Element { get set }
}

extension FixedSizeArray {
    @inline(__always)
    public static var startIndex: Index {
        indices.startIndex
    }
    
    @inline(__always)
    public static var endIndex: Index {
        indices.endIndex
    }
    
    @inline(__always)
    public static var count: Int {
        indices.count
    }
    
    @inline(__always)
    public var first: Element {
        get {
            self[startIndex]
        }
        set {
            self[startIndex] = newValue
        }
    }
    
    @inline(__always)
    public var last: Element {
        get {
            self[endIndex - 1]
        }
        set {
            self[endIndex - 1] = newValue
        }
    }
}

// MARK: -

extension FixedSizeArray where Element: AdditiveArithmetic {
    public init() {
        self.init(repeating: .zero)
    }
    
    public init(_ sequence: some Sequence<Element>) {
        self.init()
        var iterator = sequence.makeIterator()
        var index = startIndex
        while let element = iterator.next() {
            self[index] = element
            index += 1
        }
        precondition(index == endIndex, "Not enough elements in sequence")
    }
}

// MARK: -

extension FixedSizeArray {
    @inline(__always)
    public subscript(unchecked position: Index) -> Element {
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
    
    @inline(__always)
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
    
    @inline(__always)
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
