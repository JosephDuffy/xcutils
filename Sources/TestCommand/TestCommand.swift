import enum VersionSpecifier.VersionSpecifier
import enum TestRunner.Platform
import class TestRunner.TestRunner
import ArgumentParser
import Foundation

public struct TestCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "test",
        abstract: "Test macOS, iOS, and tvOS targets against simulators."
    )

    @Argument()
    var platform: Platform

    @Option(name: [.short, .customLong("version")], default: .latest)
    var versionSpecifier: VersionSpecifier

    @Option(default: "/Applications")
    var project: String

    @Option()
    var scheme: String

    public init() {}

    public func run() throws {
        try TestRunner.runTests(
            platform: platform,
            versionSpecifier: versionSpecifier,
            project: URL(fileURLWithPath: project, isDirectory: true),
            scheme: scheme
        )
    }

}
