import Foundation
import Models
import CLIHelpers
import enum Version.DecodingMethod

public enum SimulatorControl {

    public static func listRuntimes(enableVerboseLogging: Bool = false) throws -> [Runtime] {
        let decoder = JSONDecoder()
        decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant

        let runtimesData = try run(enableVerboseLogging: enableVerboseLogging, "xcrun", "simctl", "list", "runtimes", "--json")
        let decoded = try decoder.decode(RuntimesOutput.self, from: runtimesData)
        return decoded.runtimes
    }

    public static func listDevices(availableDevicesOnly: Bool = false, enableVerboseLogging: Bool = false) throws -> [String: [Simulator]] {
        var command = ["xcrun", "simctl", "list", "devices", "--json"]

        if availableDevicesOnly {
            command.append("available")
        }

        let decoder = JSONDecoder()
        decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
        let devicesData = try run(enableVerboseLogging: enableVerboseLogging, command)
        let devices = try decoder.decode(DevicesOutput.self, from: devicesData)
        return devices.devices
    }

}

private struct RuntimesOutput: Codable {
    let runtimes: [Runtime]
}

private struct DevicesOutput: Codable {
    let devices: [String: [Simulator]]
}
