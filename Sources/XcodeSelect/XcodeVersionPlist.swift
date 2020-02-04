import struct Version.Version

public struct XcodeVersionPlist: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case version = "CFBundleShortVersionString"
        case build = "ProductBuildVersion"
    }
    
    public let version: Version
    public let build: String

    public init(version: Version, build: String) {
        self.version = version
        self.build = build
    }

}
