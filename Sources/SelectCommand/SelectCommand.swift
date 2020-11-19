import VersionSpecifier
import Foundation
import XcodeSelect
import ArgumentParser
import Models
import CLIHelpers

public struct SelectCommand: ParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "select",
        abstract: "Find and select Xcode versions."
    )

    @Argument()
    var versionSpecifier: VersionSpecifier?

    @Flag(help: "Only print found versions; do not switch")
    var printVersions: Bool = false

    @Option()
    var searchPath: String = "/Applications"

    @Option(name: [.customLong("output"), .short])
    var outputFormat: OutputFormat = .humanFriendly

    @Flag(help: "Do not use spotlight index; query filesystem directly")
    var ignoreSpotlightIndex: Bool = false

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
                if let version = try XcodeSelect.findVersion(matching: versionSpecifier, from: searchPathURL, ignoreSpotlightIndex: ignoreSpotlightIndex) {
                    outputVersions([version])
                } else {
                    switch outputFormat {
                    case .humanFriendly:
                        print("No versions found matching", versionSpecifier)
                    case .json:
                        print("[]")
                    }
                }
            } else {
                let versions = try XcodeSelect.findVersions(in: searchPathURL, ignoreSpotlightIndex: ignoreSpotlightIndex)

                outputVersions(versions)
            }
        } else if let versionSpecifier = versionSpecifier {
            try XcodeSelect.selectVersion(specifier: versionSpecifier, from: searchPathURL)
        }
    }

    private func outputVersions(_ versions: [XcodeVersion]) {
        let sortedVersions = versions.sorted(by: >)
        switch outputFormat {
        case .humanFriendly:
            guard !versions.isEmpty else {
                print("Found no version at \(searchPath)")
                return
            }

            let formattedString = sortedVersions
                .map { version in
                    version.description
                }
                .joined(separator: "\n")
            print(formattedString)
        case .json:
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(sortedVersions)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    printError("JSON data was not UTF8; can't print")
                    return
                }

                print(jsonString)
            } catch {
                printError(error.localizedDescription)
            }
        }
    }

}
