extension FixedSizeArray {
    public var customMirror: Mirror {
        Mirror(self, unlabeledChildren: self, displayStyle: .collection)
    }
}
