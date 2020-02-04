import func CLIHelpers.run
import func CLIHelpers.runOutputToStandardOutput
import func CLIHelpers.printError
import func Foundation.exit
import class Foundation.JSONDecoder
import struct Version.Version
import enum Version.DecodingMethod
import class Foundation.UserDefaults

public final class TestRunner {
    
    public static func runTests(userDefaults: UserDefaults = .standard) throws {
        guard let platformString = CommandLineArguments.platform.stringValue() else {
            printError("platform argument is required")
            exit(1)
        }
        guard let scheme = CommandLineArguments.scheme.stringValue() else {
            printError("scheme argument is required")
            exit(1)
        }

        let versionString = CommandLineArguments.version.stringValue() ?? "latest"
        
        guard let platform = Platform(name: platformString, version: versionString) else {
            printError("Invalid version string", versionString)
            exit(1)
        }
        
        let project = CommandLineArguments.project.stringValue()
        
        try runTests(platform: platform, scheme: scheme, project: project)
    }
    
    public static func runTests(platform: Platform, scheme: String, project: String? = nil) throws {
        let destination: String
        
        switch platform.name.lowercased() {
        case "macos":
            destination = "platform=macOS"
        default:
            let decoder = JSONDecoder()
            decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant

            let runtimesData = try run("xcrun", "simctl", "list", "runtimes", "--json")
            let decoded = try decoder.decode(RuntimesOutput.self, from: runtimesData)
            let runtimes = decoded.runtimes

            let supportedRuntimes = runtimes.filter { $0.name.lowercased().contains(platform.name.lowercased()) }

            guard !supportedRuntimes.isEmpty else {
                printError("Found no runtimes for platform: \(platform)")
                exit(1)
            }
            
            let runtime: Runtime

            switch platform.version {
            case .latest:
                runtime = supportedRuntimes.sorted(by: { $0.version > $1.version }).first!
            case .specific(let version):
                if let foundVersion = supportedRuntimes.first(where: { $0.version == version }) {
                    runtime = foundVersion
                } else {
                    printError("Failed to find runtime with version", version)
                    exit(1)
                }
            }
            
            let devicesData = try run("xcrun", "simctl", "list", "devices", "--json")
            let devices = try decoder.decode(DevicesOutput.self, from: devicesData)
            let simulators = devices.devices

            guard let supportedSimulators = simulators[runtime.identifier] else {
                printError("Found no simulators for platform", platform)
                exit(1)
            }

            let availableSimulators = supportedSimulators.filter { $0.isAvailable }

            guard !availableSimulators.isEmpty else {
                printError("All simulators for platform \(platform) are unavailable")
                exit(1)
            }

            let simulator = availableSimulators.first(where: { $0.state == .booted }) ?? availableSimulators.first!
            destination = "id=\(simulator.udid.uuidString)"
        }

        var command: [String] = [
            "xcodebuild",
            "-scheme",
            scheme,
            "-destination",
            destination,
        ]
        
        if let project = project {
            command.append(contentsOf: [
                "-project",
                project,
            ])
        }
        
        command.append(contentsOf: [
            "build",
            "test",
        ])
        
        try runOutputToStandardOutput(command)
    }
    
}

private struct RuntimesOutput: Codable {
    let runtimes: [Runtime]
}

private struct DevicesOutput: Codable {
    let devices: [String: [Simulator]]
}
