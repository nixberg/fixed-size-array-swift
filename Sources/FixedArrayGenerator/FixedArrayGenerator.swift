import Algorithms
import ArgumentParser
import Foundation

@main
struct FixedArrayGenerator: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Generate a fixed-size array implementation for Swift.",
        version: "1.0.0-alpha"
    )
    
    @Argument(help: "The element count of the generated fixed array.")
    var count: Int
    
    @Flag(help: "Generate a public declaration.")
    var `public`: Bool = false
    
    @Flag(help: "Generate a Equatable conformance.")
    var equatable: Bool = false
    
    @Flag(help: "Generate a Hashable conformance.")
    var hashable: Bool = false
    
    func validate() throws {
        guard count > 0 else {
            throw ValidationError("Please choose a positive element count.")
        }
    }
    
    mutating func run() throws {
        var components = [baseImplementation]
        
        if equatable {
            components.append(equatableImplentation)
        }
        
        if hashable {
            components.append(hashableImplentation)
        }
        
        print(components.joined(separator: "\n\n"))
    }
    
    var publicPrefix: String {
        `public` ? "public " : ""
    }
}
