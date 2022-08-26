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

extension FixedSizeArray where Element: BinaryInteger {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        zip(lhs, rhs).lazy.map(^).reduce(.zero, |) == .zero
    }
}

extension FixedSizeArray where Element: SIMD, Element.Scalar: FixedWidthInteger {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        zip(lhs, rhs).lazy.map(^).reduce(.zero, |) == .zero
    }
}
