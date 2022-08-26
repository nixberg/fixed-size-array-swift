// TODO: Make unconditional when `storage` allows that.
extension FixedSizeArray where Element: AdditiveArithmetic {
    public init(arrayLiteral: Element...) {
        self.init(arrayLiteral)
    }
}
