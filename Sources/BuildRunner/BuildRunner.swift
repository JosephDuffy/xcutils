import Foundation
import Models
import CLIHelpers
import enum VersionSpecifier.VersionSpecifier
import struct Version.Version
import SimulatorControl

public final class BuildRunner {
    /**
     Builds a scheme using `xcodebuild`.

     - parameter platform: The platform to build the scheme for.
     - parameter versionSpecifier: The version of the platform to test.
     - parameter project: The path of the project. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.
     - parameter workspace: The path of the workfspace. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.     
     - parameter scheme: The scheme to test. For swift packages this is the target.
     - parameter buildDirectory: The directory place the build artifacts in to. Unlike `xcodebuild` this is related to the working directory, not the project.
     */
    public static func build(
        platform: Platform,
        versionSpecifier: VersionSpecifier,
        project: URL?,
        workspace: URL?,
        scheme: String,
        buildDirectory: URL?,
        enableVerboseLogging: Bool = false
    ) throws {
        let destination = try self.destination(
            for: platform,
            versionSpecifier: versionSpecifier,
            enableVerboseLogging: enableVerboseLogging
        )

        var command: [String] = [
            "xcodebuild",
            "build",
            "-scheme",
            scheme,
            "-destination",
            destination,
        ]

        project.map { project in
            command.append("-project")
            command.append(project.path)
        }

        workspace.map { workspace in
            command.append("-workspace")
            command.append(workspace.path)
        }

        buildDirectory.map { buildDirectory in
            command.append("BUILD_DIR=\(buildDirectory.path)")
        }
        
        try run(enableVerboseLogging: enableVerboseLogging, command, streamOutputTo: .standardOut)
    }

    /**
     Archives a scheme using `xcodebuild`.

     - parameter platform: The platform to build the scheme for.
     - parameter versionSpecifier: The version of the platform to test.
     - parameter project: The path of the project. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.
     - parameter workspace: The path of the workfspace. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.
     - parameter scheme: The scheme to test. For swift packages this is the target.
     - parameter archivePath: The path to output the archive to. If the path doesn't end in `.xcarchive` it will be automatically appended.
     */
    public static func archive(
        platform: Platform,
        versionSpecifier: VersionSpecifier,
        project: URL?,
        workspace: URL?,
        scheme: String,
        archivePath: String?,
        enableVerboseLogging: Bool = false
    ) throws {
        let destination = try self.destination(
            for: platform,
            versionSpecifier: versionSpecifier,
            enableVerboseLogging: enableVerboseLogging
        )

        var command: [String] = [
            "xcodebuild",
            "archive",
            "-scheme",
            scheme,
            "-destination",
            destination,
        ]

        project.map { project in
            command.append("-project")
            command.append(project.path)
        }

        workspace.map { workspace in
            command.append("-workspace")
            command.append(workspace.path)
        }

        archivePath.map { archivePath in
            command.append("-archivePath")
            command.append(archivePath)
        }

        try run(enableVerboseLogging: enableVerboseLogging, command, streamOutputTo: .standardOut)
    }

    private static func destination(
        for platform: Platform,
        versionSpecifier: VersionSpecifier,
        enableVerboseLogging: Bool
    ) throws -> String {
        switch platform {
        case .macOS:
            return "platform=macOS"
        default:
            if enableVerboseLogging {
                print("Getting available runtimes")
            }

            let runtimes = try SimulatorControl.listRuntimes(enableVerboseLogging: enableVerboseLogging)

            if enableVerboseLogging {
                print("Available runtimes:", runtimes)
            }

            let supportedRuntimes = runtimes.filter { $0.name.lowercased().contains(platform.rawValue.lowercased()) }

            guard !supportedRuntimes.isEmpty else {
                printError("Found no runtimes for platform: \(platform)")
                exit(1)
            }

            guard let runtime = supportedRuntimes.findElementWithVersion(matching: versionSpecifier, at: \.version) else {
                printError("Failed to find runtime for version", versionSpecifier)
                exit(1)
            }

            if enableVerboseLogging {
                print("Using runtime:", runtime)
            }

            let simulators = try SimulatorControl.listDevices(availableDevicesOnly: true, enableVerboseLogging: enableVerboseLogging)

            guard let supportedSimulators = simulators[runtime.identifier] else {
                printError("Found no simulators for platform", platform)
                exit(1)
            }

            guard !supportedSimulators.isEmpty else {
                printError("All simulators for platform \(platform) are unavailable")
                exit(1)
            }

            let simulator = supportedSimulators.first(where: { $0.state == .booted }) ?? supportedSimulators.first!
            return "id=\(simulator.udid.uuidString)"
        }
    }
}

private struct RuntimesOutput: Codable {
    let runtimes: [Runtime]
}

private struct DevicesOutput: Codable {
    let devices: [String: [Simulator]]
}
