extension FixedSizeArray where Element: Equatable {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        for elements in zip(lhs, rhs) {
            if elements.0 != elements.1 {
                return false
            }
        }
        return true
    }
}
