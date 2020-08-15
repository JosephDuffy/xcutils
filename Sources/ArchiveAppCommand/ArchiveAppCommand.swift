import AppArchiver
import ArgumentParser
import Foundation
import struct GlobalOptions.GlobalOptions

public struct ArchiveAppCommand: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "archive-app",
        abstract: "Create a zip archive containing an app."
    )

    @Argument()
    var appURL: String

    @Argument()
    var outputURL: String?

    @OptionGroup()
    var globalOptions: GlobalOptions

    public init() {}

    public func run() throws {
        try AppArchiver.archiveApp(
            at: URL(fileURLWithPath: appURL, isDirectory: true),
            outputTo: outputURL.map { URL(fileURLWithPath: $0, isDirectory: false) },
            enableVerboseLogging: globalOptions.verbose
        )
    }
}
