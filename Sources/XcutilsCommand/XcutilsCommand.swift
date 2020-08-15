import ArchiveAppCommand
import ArgumentParser
import TestCommand
import SelectCommand
import BuildCommand

public struct XcutilsCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        abstract: "A utility for working with Xcode.",
        subcommands: [
            ArchiveAppCommand.self,
            BuildCommand.self,
            SelectCommand.self,
            TestCommand.self,
        ]
    )

    public init() {}
}
