// TODO: Remove AdditiveArithmetic requirement when `storage` allows that.
extension FixedSizeArray where Element: AdditiveArithmetic & Decodable {
    public init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        var index = startIndex
        while !container.isAtEnd {
            self[index] = try container.decode(Element.self)
            index += 1
        }
        precondition(index == endIndex, "Not enough elements in container")
    }
}
