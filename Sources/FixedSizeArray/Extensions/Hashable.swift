extension FixedSizeArray where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Self.count)
        for element in self {
            hasher.combine(element)
        }
    }
}
