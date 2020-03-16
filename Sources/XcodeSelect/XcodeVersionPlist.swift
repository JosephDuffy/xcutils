import struct Version.Version

public struct XcodeVersionPlist: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case version = "CFBundleShortVersionString"
        case bundleVersion = "CFBundleVersion"
        case build = "ProductBuildVersion"
    }
    
    public let version: Version
    public let bundleVersion: Float
    public let build: String

    public init(version: Version, bundleVersion: Float, build: String) {
        self.version = version
        self.bundleVersion = bundleVersion
        self.build = build
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        version = try container.decode(Version.self, forKey: .version)

        let bundleVersionString = try container.decode(String.self, forKey: .bundleVersion)
        guard let bundleVersion = Float(argument: bundleVersionString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.bundleVersion, in: container, debugDescription: "Bundle version must be a valid float")
        }

        self.bundleVersion = bundleVersion

        build = try container.decode(String.self, forKey: .build)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version, forKey: .version)
        try container.encode("\(bundleVersion)", forKey: .bundleVersion)
        try container.encode(build, forKey: .build)
    }

}
