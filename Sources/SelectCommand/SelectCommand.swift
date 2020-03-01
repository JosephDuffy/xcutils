import enum VersionSpecifier.VersionSpecifier
import Foundation
import class XcodeSelect.XcodeSelect
import ArgumentParser

public struct SelectCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "select",
        abstract: "Find and select Xcode versions."
    )

    @Argument()
    var versionSpecifier: VersionSpecifier?

    @Flag()
    var printVersions: Bool

    @Option(default: "/Applications")
    var searchPath: String

    private var searchPathURL: URL {
        return URL(fileURLWithPath: searchPath, isDirectory: true)
    }

    public init() {}

    public func validate() throws {
        guard printVersions || versionSpecifier != nil else {
            throw ValidationError("Either a version specifier or the --printVersions flag is required. See --help.")
        }
    }

    public func run() throws {
        if printVersions {
            if let versionSpecifier = versionSpecifier {
                if let version = try XcodeSelect.findVersion(matching: versionSpecifier, from: searchPathURL) {
                    print(version)
                } else {
                    print("No versions found matching", versionSpecifier)
                }
            } else {
                let versions = try XcodeSelect.findVersions(in: searchPathURL)

                if !versions.isEmpty {
                    print(versions.sorted(by: >).map { version in
                        version.description
                    }.joined(separator: "\n"))
                } else {
                    throw SelectCommandError.foundNoVersions(path: searchPathURL)
                }
            }
        } else if let versionSpecifier = versionSpecifier {
            try XcodeSelect.selectVersion(specifier: versionSpecifier, from: searchPathURL)
        }
    }

}
