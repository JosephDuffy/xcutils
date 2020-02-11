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

        guard let matchedVersion = xcodeVersions.map({ $0.version }).findVersion(matching: specifier) else {
            return nil
        }

        return xcodeVersions.first(where: { $0.version == matchedVersion })!
    }

    public static func selectVersion(_ version: XcodeVersion) throws {
        let command: [String] = [
            "sudo",
            "xcodeselect",
            "--switch",
            version.path.absoluteString,
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

public enum SelectVersionError: Error, LocalizedError {
    case noVersionMatchingSpecifier(VersionSpecifier)

    public var errorDescription: String? {
        switch self {
        case .noVersionMatchingSpecifier(let versionSpecifier):
            return "No version found matching \(versionSpecifier)"
        }
    }
}
