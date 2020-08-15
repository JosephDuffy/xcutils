import enum VersionSpecifier.VersionSpecifier
import TestRunner
import ArgumentParser
import Foundation
import struct GlobalOptions.GlobalOptions
import Models

public struct TestCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "test",
        abstract: "Test macOS, iOS, and tvOS targets against simulators."
    )

    @Argument()
    var platform: Platform

    @Option(name: [.short, .customLong("version")])
    var versionSpecifier: VersionSpecifier = .latest

    @Option()
    var project: String?

    @Option()
    var workspace: String?

    @Option()
    var scheme: String

    @Flag(inversion: .prefixedEnableDisable, help: "Explicitly enable or disable code coverage. If this flag is ommited the project's settings will be used")
    var codeCoverage: Bool?

    @OptionGroup()
    var globalOptions: GlobalOptions

    public init() {}

    public func run() throws {
        try TestRunner.runTests(
            platform: platform,
            versionSpecifier: versionSpecifier,
            project: project.map { URL(fileURLWithPath: $0, isDirectory: true) },
            workspace: workspace.map { URL(fileURLWithPath: $0, isDirectory: true) },
            scheme: scheme,
            enableCodeCoverage: codeCoverage,
            enableVerboseLogging: globalOptions.verbose
        )
    }

}
