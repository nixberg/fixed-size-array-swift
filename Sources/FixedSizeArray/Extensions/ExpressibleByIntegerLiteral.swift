extension FixedSizeArray where Element: BinaryInteger {
    @_transparent
    public init(integerLiteral value: Int) {
        self.init(repeating: Element(value))
    }
}
