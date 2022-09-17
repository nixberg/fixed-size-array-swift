import Algorithms
import ArgumentParser
import Foundation

@main
struct FixedSizeArrayGenerator: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Generate a fixed-size array implementation for Swift."
    )
    
    @Argument(help: "The element count of the generated type.")
    var count: Int
    
    @Option(help: "The element type of the generated type. By default, the type is generic.")
    var element: String?
    
    @Option(help: #"The name of the generated type. (default: "Array\(count)")"#)
    var name: String?
    
    @Option(
        name: .customLong("conformance"),
        help: "A protocol the generated type will conform to. Ignored when the type is generic."
    )
    var conformances: [String] = []
    
    @Option(help: "The output file.")
    var outputFile: String?
    
    @Flag(help: "Generate a public type declaration.")
    var `public`: Bool = false
    
    func validate() throws {
        guard count > 0 else {
            throw ValidationError("Please choose a positive element count.")
        }
    }
    
    mutating func run() throws {
        let name = name ?? "Array\(count)"
        
        var components = ["""
        \(`public` ? "@_exported " : "")import FixedSizeArray
        """]
        
        if let element = element {
            components.append("""
        \(publicPrefix)struct \(name): FixedSizeArray {
            
            \(publicPrefix)typealias Element = \(element)
        """)
        } else {
            components.append("""
        \(publicPrefix)struct \(name)<Element>: FixedSizeArray {
        """)
        }
        
        components.append("""
            \(publicPrefix)typealias Index = Int
            
            private var storage: (
        \(repeatElement("Element", count: count)
            .lazy
            .chunks(ofCount: 8)
            .map({ "        " + $0.joined(separator: ", ") })
            .joined(separator: ",\n"))
            )
            
            @inline(__always)
            \(publicPrefix)static var indices: Range<Index> {
                0..<\(count)
            }
            
            @inline(__always)
            \(publicPrefix)init(repeating element: Element) {
                storage = (
        \(repeatElement("element", count: count)
            .lazy
            .chunks(ofCount: 8)
            .map({ "            " + $0.joined(separator: ", ") })
            .joined(separator: ",\n"))
                )
            }
            
            @inline(__always)
            \(publicPrefix)init(
        \((0..<count)
                .lazy
                .map({ "        _ e\($0): Element" })
                .joined(separator: ",\n"))
            ) {
                storage = (
        \((0..<count)
                .lazy
                .map({ "            e\($0)" })
                .joined(separator: ",\n"))
                )
            }
        }
        """)
        
        if element != nil {
            if !conformances.isEmpty {
                components.append(conformances.map { conformance in
                    "extension \(name): \(conformance) {}"
                }.joined(separator: "\n\n"))
            }
        } else {
            components.append("""
        extension \(name): Decodable where Element: AdditiveArithmetic & Decodable {}
        
        extension \(name): Encodable where Element: Encodable {}
        
        extension \(name): Equatable where Element: Equatable {}
        
        extension \(name): ExpressibleByArrayLiteral where Element: AdditiveArithmetic {}
        
        extension \(name): Hashable where Element: Hashable {}
        
        extension \(name): Sendable where Element: Sendable {}
        
        #if canImport(Subtle)
        import Subtle
        
        extension \(name): ConstantTimeEquatable where Element: ConstantTimeEquatable {}
                
        extension \(name): ConstantTimeSortable
        where Element: ConstantTimeGreaterThan & ConditionallyReplaceable {}
        
        extension \(name): Zeroizable where Element: Zeroizable {}
        #endif
        """)
        }
        
        let result = components.joined(separator: "\n\n")
                      
        if let outputFile = outputFile {
            try result.write(toFile: outputFile, atomically: true, encoding: .utf8)
        } else {
            print(result)
        }
    }
    
    private var publicPrefix: String {
        `public` ? "public " : ""
    }
}
