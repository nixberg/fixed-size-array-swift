import Foundation
import PackagePlugin

@main
struct FixedSizeArrayGeneratorPlugin: BuildToolPlugin {
    enum Error: Swift.Error {
        case invalidTarget
    }
    
    struct ConfigurationEntry: Decodable {
        enum Visibility: String, Codable, CustomStringConvertible {
            case `internal`
            case `package`
            case `public`
            
            var description: String {
                rawValue
            }
        }
        
        let count: Int
        let visibility: Visibility
    }
    
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            throw Error.invalidTarget
        }
        
        let executable = try context.tool(named: "generate-fixed-size-array").path
        
        let configuration = try Configuration(directory: target.directory)
        
        FileManager.default.cleanDirectory(context.pluginWorkDirectory)
        
        return configuration.map { entry in
            let fileName = "Array\(entry.count).swift"
            let path = context.pluginWorkDirectory.appending(subpath: fileName)
            return .buildCommand(
                displayName: "Generating \(fileName)",
                executable: executable,
                arguments: [
                    "--output-file", path,
                    "--visibility", entry.visibility,
                    "--", entry.count
                ],
                outputFiles: [path])
        }
    }
}

fileprivate typealias Configuration = [FixedSizeArrayGeneratorPlugin.ConfigurationEntry]

fileprivate extension Configuration {
    init(directory: Path) throws {
        let configurationFilePath = directory.appending(subpath: "fixed-size-arrays.json")
        let data = try Data(contentsOf: URL(fileURLWithPath: configurationFilePath.string))
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

fileprivate extension FileManager {
    func cleanDirectory(_ directory: Path) {
        try? removeItem(atPath: directory.string)
        try? createDirectory(atPath: directory.string, withIntermediateDirectories: false)
    }
}
