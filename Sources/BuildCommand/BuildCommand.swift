import enum VersionSpecifier.VersionSpecifier
import BuildRunner
import ArgumentParser
import Foundation
import struct GlobalOptions.GlobalOptions
import Models

public struct BuildCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Build macOS, iOS, and tvOS targets."
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

    @Option()
    var buildDirectory: String?

    @OptionGroup()
    var globalOptions: GlobalOptions

    public init() {}

    public func run() throws {
        try BuildRunner.build(
            platform: platform,
            versionSpecifier: versionSpecifier,
            project: project.map { URL(fileURLWithPath: $0, isDirectory: true) },
            workspace: workspace.map { URL(fileURLWithPath: $0, isDirectory: true) },
            scheme: scheme,
            buildDirectory: buildDirectory.map { URL(fileURLWithPath: $0, isDirectory: true) },
            enableVerboseLogging: globalOptions.verbose
        )
    }

}
