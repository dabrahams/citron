// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Define a constant to clean up dependency management for SPM bug workarounds (see
// LocalTargetCommandDemoPlugin below).  Swift only allows conditional compilation at statement
// granularity so that becomes very inconvenient otherwise.
#if os(Windows)
let osIsWindows = true
#else
let osIsWindows = false
#endif

let package = Package(
    name: "citron",
    products: [
        .executable(name: "citron", targets: ["citron"]),
        .library(name: "CitronParserModule", targets: ["CitronParserModule"]),
        .library(name: "CitronLexerModule", targets: ["CitronLexerModule"]),
        .plugin(name: "CitronParserGenerator", targets: ["CitronParserGenerator"])
    ],
    targets: [
      .executableTarget(name: "citron", dependencies: ["CitronCLibrary"]),
      .target(name: "CitronParserModule", exclude: ["LICENSE.txt"]),
      .target(name: "CitronLexerModule", exclude: ["LICENSE.txt"]),
      .target(name: "CitronCLibrary"),
      .plugin(
        name: "CitronParserGenerator", capability: .buildTool(),
        dependencies: osIsWindows ? [] : ["citron"]),

      // Examples
      .executableTarget(
        name: "expr",
        dependencies: ["CitronParserModule", "CitronLexerModule"],
        path: "examples/expr",
        exclude: ["README.md", "Makefile"],
        plugins: [.plugin(name: "CitronParserGenerator")]),

      .executableTarget(
        name: "expr_ec",
        dependencies: ["CitronParserModule", "CitronLexerModule"],
        path: "examples/expr_ec",
        exclude: ["README.md", "Makefile"],
        plugins: [.plugin(name: "CitronParserGenerator")]),

      .executableTarget(
        name: "functype",
        dependencies: ["CitronParserModule", "CitronLexerModule"],
        path: "examples/functype",
        exclude: ["README.md", "Makefile"],
        plugins: [.plugin(name: "CitronParserGenerator")]),

      .executableTarget(
        name: "functype_ec",
        dependencies: ["CitronParserModule", "CitronLexerModule"],
        path: "examples/functype_ec",
        exclude: ["README.md", "Makefile"],
        plugins: [.plugin(name: "CitronParserGenerator")]),

      .testTarget(
          name: "CitronTests",
          dependencies: ["expr", "expr_ec", "functype", "functype_ec"]
      ),
    ]
)
