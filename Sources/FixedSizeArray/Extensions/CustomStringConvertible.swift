extension FixedSizeArray {
    public var description: String {
        var isFirst = true
        var result = self.reduce(into: "[") {
            if isFirst {
                isFirst = false
            } else {
                $0 += ", "
            }
            debugPrint($1, terminator: "", to: &$0)
        }
        result += "]"
        return result
    }
    
    public var debugDescription: String {
        description
    }
}
