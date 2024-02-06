// TODO: Remove AdditiveArithmetic requirement when `storage` allows that.
extension FixedSizeArray where Element: AdditiveArithmetic & Decodable {
    public init(from decoder: Decoder) throws {
        self.init(repeating: .zero)
        var container = try decoder.unkeyedContainer()
        var index = startIndex
        while !container.isAtEnd {
            precondition(index != endIndex, "Too many elements in container")
            self[index] = try container.decode(Element.self)
            index += 1
        }
        precondition(index == endIndex, "Not enough elements in container")
    }
}
