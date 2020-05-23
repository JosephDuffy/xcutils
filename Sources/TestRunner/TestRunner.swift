import func CLIHelpers.run
import func CLIHelpers.printError
import func Foundation.exit
import class Foundation.JSONDecoder
import struct Version.Version
import enum Version.DecodingMethod
import class Foundation.UserDefaults
import enum VersionSpecifier.VersionSpecifier
import struct Foundation.URL

public final class TestRunner {

    /**
     Run tests using `xcodebuild`.

     - parameter platform: The platform to test.
     - parameter versionSpecifier: The version of the platform to test.
     - parameter project: The path of the project. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.
     - parameter workspace: The path of the workfspace. Can be `nil` if inside a directory with an Xcode project, Xcode workspace, or a swift package.     
     - parameter scheme: The scheme to test. For swift packages this is the target.
     */
    public static func runTests(
        platform: Platform,
        versionSpecifier: VersionSpecifier,
        project: URL?,
        workspace: URL?,
        scheme: String,
        enableVerboseLogging: Bool = false
    ) throws {
        let destination: String
        
        switch platform {
        case .macOS:
            destination = "platform=macOS"
        default:
            let decoder = JSONDecoder()
            decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant

            if enableVerboseLogging {
                print("Getting available runtimes")
            }

            let runtimesData = try run(enableVerboseLogging: enableVerboseLogging, "xcrun", "simctl", "list", "runtimes", "--json")
            let decoded = try decoder.decode(RuntimesOutput.self, from: runtimesData)
            let runtimes = decoded.runtimes

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
            
            let devicesData = try run(enableVerboseLogging: enableVerboseLogging, "xcrun", "simctl", "list", "devices", "available", "--json")
            let devices = try decoder.decode(DevicesOutput.self, from: devicesData)
            let simulators = devices.devices

            guard let supportedSimulators = simulators[runtime.identifier] else {
                printError("Found no simulators for platform", platform)
                exit(1)
            }

            guard !supportedSimulators.isEmpty else {
                printError("All simulators for platform \(platform) are unavailable")
                exit(1)
            }

            let simulator = supportedSimulators.first(where: { $0.state == .booted }) ?? supportedSimulators.first!
            destination = "id=\(simulator.udid.uuidString)"
        }

        var command: [String] = [
            "xcodebuild",
            "test",
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
        
        try run(enableVerboseLogging: enableVerboseLogging, command)
    }
    
}

private struct RuntimesOutput: Codable {
    let runtimes: [Runtime]
}

private struct DevicesOutput: Codable {
    let devices: [String: [Simulator]]
}
