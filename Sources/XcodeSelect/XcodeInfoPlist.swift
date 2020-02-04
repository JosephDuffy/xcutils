import struct Version.Version

public struct XcodeInfoPlist: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case iconFileName = "CFBundleIconFile"
    }
    
    public let iconFileName: String

    public init(iconFileName: String) {
        self.iconFileName = iconFileName
    }

}
