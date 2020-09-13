import Foundation
import enum VersionSpecifier.VersionSpecifier
import func CLIHelpers.run

public final class XcodeSelect {
    
    public static func findVersions(in directory: URL, ignoreSpotlightIndex: Bool = false) throws -> [XcodeVersion] {
        if ignoreSpotlightIndex {
            let xcodePaths = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: []
            ).filter { $0.lastPathComponent.starts(with: "Xcode") && $0.hasDirectoryPath }
            return xcodePaths.compactMap { try? XcodeVersion(url: $0) }.sorted(by: >)
        } else {
            let command: [String] = [
                "mdfind",
                "kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'",
                "-onlyin",
                directory.path,
            ]

            let outputData = try run(command)
            let output = String(data: outputData, encoding: .utf8)!
            let xcodePaths = output.split(separator: "\n").map { URL(fileURLWithPath: String($0), isDirectory: true) }
            return xcodePaths.compactMap { try? XcodeVersion(url: $0) }.sorted(by: >)
        }
    }

    public static func findVersion(matching specifier: VersionSpecifier, from directory: URL, ignoreSpotlightIndex: Bool = false) throws -> XcodeVersion? {
        let xcodeVersions = try findVersions(in: directory, ignoreSpotlightIndex: ignoreSpotlightIndex)

        return xcodeVersions.findElementWithVersion(matching: specifier, at: \.version)
    }

    public static func selectVersion(_ version: XcodeVersion) throws {
        guard ProcessInfo.processInfo.environment["USER"] == "root" else {
            throw SelectVersionError.requiresRoot
        }

        let command: [String] = [
            "xcode-select",
            "--switch",
            version.path.path,
        ]

        try run(command, streamOutputTo: .standardOut)
    }

    public static func selectVersion(specifier: VersionSpecifier, from directory: URL) throws {
        guard let matchedVersion = try findVersion(matching: specifier, from: directory) else {
            throw SelectVersionError.noVersionMatchingSpecifier(specifier)
        }

        try selectVersion(matchedVersion)
    }
    
}
