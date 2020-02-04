import Foundation
import Version

public struct XcodeVersion: Comparable, CustomStringConvertible {
    
    public static func < (lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        if lhs.version == rhs.version {
            return lhs.isBeta && !rhs.isBeta
        } else {
            return lhs.version < rhs.version
        }
    }
    
    public let version: Version
    public let build: String
    public let isBeta: Bool
    
    public var description: String {
        return "Xcode\(isBeta ? " Beta" : "") \(version) (\(build))"
    }
    
    public init?(url: URL) {
        let decoder = PropertyListDecoder()
        decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
        let infoPlistURL = url.appendingPathComponent("Contents/Info.plist", isDirectory: false)
        let versionPlistURL = url.appendingPathComponent("Contents/version.plist", isDirectory: false)
        
        guard let infoPlistData = FileManager.default.contents(atPath: infoPlistURL.path) else { return nil }
        guard let versionPlistData = FileManager.default.contents(atPath: versionPlistURL.path) else { return nil }
        
        do {
            var format = PropertyListSerialization.PropertyListFormat.binary
            let infoPlist = try decoder.decode(XcodeInfoPlist.self, from: infoPlistData, format: &format)
            let versionPlist = try decoder.decode(XcodeVersionPlist.self, from: versionPlistData, format: &format)
            version = versionPlist.version
            build = versionPlist.build
            isBeta = infoPlist.iconFileName.hasSuffix("Beta")
        } catch {
            return nil
        }
    }

    public init(version: Version, build: String, isBeta: Bool) {
        self.version = version
        self.build = build
        self.isBeta = isBeta
    }
    
}
