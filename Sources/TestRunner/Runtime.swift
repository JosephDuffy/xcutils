import Foundation
import struct Version.Version

public struct Runtime: Codable {
    public let version: Version
    public let bundlePath: String
    public let isAvailable: Bool
    public let name: String
    public let identifier: String
    public let buildversion: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let versionString = try container.decode(String.self, forKey: .version)
        version = try Version(tolerant: versionString)
            .unwrapOrThrow(
                DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.version],
                        debugDescription: "Invalid semantic version"
                    )
                )
            )
        bundlePath = try container.decode(String.self, forKey: .bundlePath)
        isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)
        buildversion = try container.decode(String.self, forKey: .buildversion)
    }
    
}

extension Optional {
    
    func unwrapOrThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw error()
        }
    }
    
}
