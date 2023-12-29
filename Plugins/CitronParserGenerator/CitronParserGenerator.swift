import PackagePlugin

@main
struct CitronParserGenerator: SPMBuildToolPlugin {

  func buildCommands(context: PluginContext, target: Target) throws -> [SPMBuildCommand] {
    guard let target = target as? SourceModuleTarget else { return [] }
    let inputFiles = target.sourceFiles.filter({ [ "citron", "y"].contains($0.path.extension) })
    return inputFiles.map {
      let inputFile = $0
      let inputPath = inputFile.path
      let outputName = inputPath.stem + ".swift"
      let outputPath = context.pluginWorkDirectory.appending(outputName)
      return .buildCommand(
        displayName: "Generating \(outputName) from \(inputPath.lastComponent)",
        executable: .targetInThisPackage("citron"),
        arguments: [ "\(inputPath.platformString)", "-o", "\(outputPath.platformString)" ],
        inputFiles: [ inputPath, ],
        outputFiles: [ outputPath ]
      )
    }
  }}
