import Foundation
import enum VersionSpecifier.VersionSpecifier
import func CLIHelpers.runOutputToStandardOutput

public final class XcodeSelect {
    
    public static func findVersions(in directory: URL) throws -> [XcodeVersion] {
        let xcodePaths = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: []
        ).filter { $0.lastPathComponent.starts(with: "Xcode") && $0.hasDirectoryPath }
        return xcodePaths.compactMap(XcodeVersion.init(url:))
    }

    public static func findVersion(matching specifier: VersionSpecifier, from directory: URL) throws -> XcodeVersion? {
        let xcodeVersions = try findVersions(in: directory)

        return xcodeVersions.findElementWithVersion(matching: specifier, at: \.version)
    }

    public static func selectVersion(_ version: XcodeVersion) throws {
        guard ProcessInfo.processInfo.environment["USER"] == "root" else {
            // TODO: Fallback to running command with `sudo` and pipe stdin
            throw SelectVersionError.requiresRoot
        }

        let command: [String] = [
            "xcode-select",
            "--switch",
            version.path.path,
        ]

        try runOutputToStandardOutput(command)
    }

    public static func selectVersion(specifier: VersionSpecifier, from directory: URL) throws {
        guard let matchedVersion = try findVersion(matching: specifier, from: directory) else {
            throw SelectVersionError.noVersionMatchingSpecifier(specifier)
        }

        try selectVersion(matchedVersion)
    }
    
}
