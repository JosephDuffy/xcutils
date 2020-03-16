import Foundation
import struct XcodeSelect.XcodeInfoPlist
import struct XcodeSelect.XcodeVersionPlist
import struct XcodeSelect.XcodeVersion

extension XcodeVersion {
    internal func writeToPath() throws {
        let contentsDirectory = path.appendingPathComponent("Contents", isDirectory: true)
        
        let infoPlistEncoder = PropertyListEncoder()
        infoPlistEncoder.outputFormat = .binary
        let infoPlist = XcodeInfoPlist(iconFileName: "Xcode\(isBeta ? "Beta" : "")")
        let infoPlistData = try infoPlistEncoder.encode(infoPlist)
        let infoPlistURL = contentsDirectory.appendingPathComponent("Info.plist", isDirectory: false)
        
        let versionPlistEncoder = PropertyListEncoder()
        let versionPlist = XcodeVersionPlist(version: version, bundleVersion: 12345.1, build: build)
        let versionPlistData = try versionPlistEncoder.encode(versionPlist)
        let versionPlistURL = contentsDirectory.appendingPathComponent("version.plist", isDirectory: false)
        
        try FileManager.default.createDirectory(at: contentsDirectory, withIntermediateDirectories: true, attributes: nil)
        FileManager
            .default
            .createFile(
                atPath: infoPlistURL.path,
                contents: infoPlistData,
                attributes: nil
            )
        FileManager
            .default
            .createFile(
                atPath: versionPlistURL.path,
                contents: versionPlistData,
                attributes: nil
            )
    }
}
