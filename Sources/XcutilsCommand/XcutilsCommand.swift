import protocol ArgumentParser.ParsableCommand
import struct ArgumentParser.CommandConfiguration
import struct TestCommand.TestCommand
import struct SelectCommand.SelectCommand
import struct BuildCommand.BuildCommand

public struct XcutilsCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        abstract: "A utility for working with Xcode.",
        subcommands: [TestCommand.self, SelectCommand.self, BuildCommand.self]
    )

    public init() {}
}
