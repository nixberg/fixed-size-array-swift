import Algorithms
import ArgumentParser
import Foundation

@main
struct FixedSizeArrayGenerator: ParsableCommand {
    enum Visibility: String, ExpressibleByArgument {
        case `internal`
        case `package`
        case `public`
    }
    
    static var configuration = CommandConfiguration(
        abstract: "Generate a fixed-size array implementation for Swift."
    )
    
    @Argument(help: "The element count of the generated type.")
    var count: Int
    
    @Option(help: "The output file.")
    var outputFile: String?
    
    @Option(help: "Generate a public type declaration.")
    var visibility: Visibility = .internal
    
    func validate() throws {
        guard count > 0 else {
            throw ValidationError("Please choose a positive element count.")
        }
    }
    
    mutating func run() throws {
        var result = """
        @_exported import FixedSizeArray
        
        extension Array\(count): Decodable where Element: AdditiveArithmetic & Decodable {}
        extension Array\(count): Encodable where Element: Encodable {}
        extension Array\(count): Equatable where Element: Equatable {}
        extension Array\(count): ExpressibleByArrayLiteral where Element: AdditiveArithmetic {}
        extension Array\(count): Hashable where Element: Hashable {}
        
        public struct Array\(count)<Element>: FixedSizeArray {
            public typealias Index = Int
            
            public static var count: Int { \(count) }
            
            private var storage: (\(repeatElement("Element", count: count).joined(separator: ", ")))
            
            public init(repeating element: Element) {
                storage = (\(repeatElement("element", count: count).joined(separator: ", ")))
            }
            
            public init(\(String((0..<count).map({ "_ e\($0): Element" }).joined(by: ", ")))) {
                storage = (\(String((0..<count).map({ "e\($0)" }).joined(by: ", "))))
            }
        }
        """
        
        switch visibility {
        case .internal:
            result.replace("@_exported ", with: "")
            result.replace("public ", with: "")
        case .package:
            result.replace("public ", with: "package ")
        case .public:
            break
        }
        
        if let outputFile {
            try result.write(toFile: outputFile, atomically: true, encoding: .utf8)
        } else {
            print(result)
        }
    }
}

extension String {
    fileprivate mutating func replace(_ target: String, with replacement: String) {
        self = self.replacingOccurrences(of: target, with: replacement)
    }
}
