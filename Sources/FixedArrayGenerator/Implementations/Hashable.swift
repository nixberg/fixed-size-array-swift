extension FixedArrayGenerator {
    var hashableImplentation: String {
        """
        // MARK: - Hashable
        
        extension Array\(count): Hashable where Element: Hashable {
            \(publicPrefix)func hash(into hasher: inout Hasher) {
                hasher.combine(Self.count)
                for element in self {
                    hasher.combine(element)
                }
            }
        }
        """
    }
}
