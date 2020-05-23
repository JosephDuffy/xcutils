import ArgumentParser

public struct GlobalOptions: ParsableArguments {
    @Flag(help: "Enable verbose logging")
    public var verbose: Bool

    public init() {}
}
