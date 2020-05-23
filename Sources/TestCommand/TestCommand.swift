import enum VersionSpecifier.VersionSpecifier
import TestRunner
import ArgumentParser
import Foundation
import struct GlobalOptions.GlobalOptions

public struct TestCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "test",
        abstract: "Test macOS, iOS, and tvOS targets against simulators."
    )

    @Argument()
    var platform: Platform

    @Option(name: [.short, .customLong("version")], default: .latest)
    var versionSpecifier: VersionSpecifier

    @Option()
    var project: String?

    @Option()
    var scheme: String

    @OptionGroup()
    var globalOptions: GlobalOptions

    public init() {}

    public func run() throws {
        try TestRunner.runTests(
            platform: platform,
            versionSpecifier: versionSpecifier,
            project: project.map { URL(fileURLWithPath: $0, isDirectory: true) },
            scheme: scheme,
            enableVerboseLogging: globalOptions.verbose
        )
    }

}
