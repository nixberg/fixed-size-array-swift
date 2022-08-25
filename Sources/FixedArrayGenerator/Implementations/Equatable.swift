extension FixedArrayGenerator {
    var equatableImplentation: String {
        """
        // MARK: - Equatable
        
        extension Array\(count): Equatable where Element: Equatable {
            \(publicPrefix)static func == (_ lhs: Self, _ rhs: Self) -> Bool {
                for elements in zip(lhs, rhs) {
                    if elements.0 != elements.1 {
                        return false
                    }
                }
                return true
            }
        }
        
        extension Array\(count) where Element: BinaryInteger {
            \(publicPrefix)static func == (_ lhs: Self, _ rhs: Self) -> Bool {
                zip(lhs, rhs).lazy.map(^).reduce(.zero, |) == .zero
            }
        }
        
        extension Array\(count) where Element: SIMD, Element.Scalar: FixedWidthInteger {
            \(publicPrefix)static func == (_ lhs: Self, _ rhs: Self) -> Bool {
                zip(lhs, rhs).lazy.map(^).reduce(.zero, |) == .zero
            }
        }
        """
    }
}
