import Foundation
import PackagePlugin

@main
struct FixedSizeArrayGeneratorPlugin: BuildToolPlugin {
    enum Error: Swift.Error {
        case invalidTarget
    }
    
    struct ConfigurationEntry: Decodable {
        enum Visibility: String, Codable {
            case `internal`
            case `public`
        }
        
        let count: Int
        let visibility: Visibility
        
        var fileName: String {
            "Array\(count).swift"
        }
        
        enum CodingKeys: String, CodingKey {
            case count
            case visibility
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            count = try values.decode(Int.self, forKey: .count)
            visibility = (try? values.decode(Visibility.self, forKey: .visibility)) ?? .internal
        }
    }
    
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            throw Error.invalidTarget
        }
        
        let executable = try context.tool(named: "generate-fixed-size-array").path
        
        let configuration = try Configuration(directory: target.directory)
        
        FileManager.default.cleanDirectory(context.pluginWorkDirectory)
        
        return configuration.map { entry in
            let path = context.pluginWorkDirectory.appending(subpath: entry.fileName)
            
            var arguments: [CustomStringConvertible] = [
                "--output-file", path
            ]
            if case .public = entry.visibility {
                arguments.append("--public")
            }
            arguments.append(contentsOf: [
                "--", entry.count
            ])
            
            return .buildCommand(
                displayName: "Generating \(entry.fileName)",
                executable: executable,
                arguments: arguments,
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
