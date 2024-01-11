import CitronCLibrary

@main struct CitronExecutable {
  static func main() {
    _ = main_(CommandLine.argc, CommandLine.unsafeArgv)
  }
}
