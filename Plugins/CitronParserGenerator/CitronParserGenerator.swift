import PackagePlugin
import Foundation

extension URL {
  var fileSystemRepresentation: String {
     self.withUnsafeFileSystemRepresentation { String(cString: $0!) }
   }
}

@main
struct CitronParserGenerator: BuildToolPlugin {

  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    guard let target = target as? SourceModuleTarget else { return [] }
    let inputFiles = target.sourceFiles.filter({ [ "citron", "y"].contains($0.url.pathExtension) })
    return try inputFiles.map {
      let inputFile = $0
      let inputURL = inputFile.url
      let outputName = inputURL.deletingPathExtension().appendingPathExtension("swift").absoluteString
      let outputURL = context.pluginWorkDirectoryURL.appendingPathComponent(outputName)
      return Command.buildCommand(
        displayName: "Generating \(outputName) from \(inputURL.lastPathComponent)",
        executable: try context.tool(named: "citron").url,
        arguments: [ "\(inputURL.fileSystemRepresentation)", "-o", "\(outputURL.fileSystemRepresentation)" ],
        inputFiles: [ inputURL ],
        outputFiles: [ outputURL ]      )
    }
  }}
