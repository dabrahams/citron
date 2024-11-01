import PackagePlugin
import Foundation

@main
struct CitronParserGenerator: SPMBuildToolPlugin {

  func buildCommands(context: PluginContext, target: Target) throws -> [SPMBuildCommand] {
    guard let target = target as? SourceModuleTarget else { return [] }
    let inputFiles = target.sourceFiles.filter({ [ "citron", "y"].contains($0.url.pathExtension) })
    return inputFiles.map {
      let inputFile = $0
      let inputURL = inputFile.url
      let outputName = inputURL.deletingPathExtension().appendingPathExtension("swift").absoluteString
      let outputURL = context.pluginWorkDirectoryURL.appendingPathComponent(outputName)
      return .buildCommand(
        displayName: "Generating \(outputName) from \(inputURL.lastPathComponent)",
        executable: .targetInThisPackage("citron"),
        arguments: [ "\(inputURL.fileSystemRepresentation)", "-o", "\(outputURL.fileSystemRepresentation)" ],
        inputFiles: [ inputURL ],
        outputFiles: [ outputURL ]      )
    }
  }}
