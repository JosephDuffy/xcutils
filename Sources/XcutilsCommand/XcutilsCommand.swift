import protocol ArgumentParser.ParsableCommand
import struct ArgumentParser.CommandConfiguration
import struct TestCommand.TestCommand
import struct SelectCommand.SelectCommand

public struct XcutilsCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        abstract: "A utility for working with Xcode.",
        subcommands: [TestCommand.self, SelectCommand.self]
    )

    public init() {}
}
