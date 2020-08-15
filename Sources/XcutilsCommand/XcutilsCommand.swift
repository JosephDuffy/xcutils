import ArchiveAppCommand
import ArgumentParser
import NotarizeCommand
import TestCommand
import SelectCommand
import BuildCommand

public struct XcutilsCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "xcutils",
        abstract: "A utility for working with Xcode.",
        subcommands: [
            ArchiveAppCommand.self,
            BuildCommand.self,
            NotarizeCommand.self,
            SelectCommand.self,
            TestCommand.self,
        ]
    )

    public init() {}
}
