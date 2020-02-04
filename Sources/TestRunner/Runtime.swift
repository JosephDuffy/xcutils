import Foundation
import struct Version.Version

public struct Runtime: Codable {
    public let version: Version
    public let bundlePath: String
    public let isAvailable: Bool
    public let name: String
    public let identifier: String
    public let buildversion: String
}
