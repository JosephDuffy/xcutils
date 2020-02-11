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

    public let path: URL
    public let version: Version
    public let build: String
    public var isBeta: Bool {
        return version.prereleaseIdentifiers.contains("beta")
    }
    
    public var description: String {
        return "Xcode \(version) (\(build)) at \(path.path)"
    }
    
    public init?(url: URL) {
        path = url

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

            if infoPlist.iconFileName.hasSuffix("Beta") {
                version = Version(
                    major: versionPlist.version.major,
                    minor: versionPlist.version.minor,
                    patch: versionPlist.version.patch,
                    prereleaseIdentifiers: versionPlist.version.prereleaseIdentifiers + ["beta"],
                    buildMetadataIdentifiers: versionPlist.version.buildMetadataIdentifiers
                )
            } else {
                version = versionPlist.version
            }

            build = versionPlist.build
        } catch {
            return nil
        }
    }

    public init(path: URL, version: Version, build: String) {
        self.path = path
        self.version = version
        self.build = build
    }
    
}
