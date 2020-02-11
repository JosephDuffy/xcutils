import struct XcodeSelect.XcodeVersion
import struct Version.Version
import struct Foundation.URL

extension XcodeVersion {

    static func v11_1_gm(at path: URL) -> XcodeVersion {
        let version = Version(major: 11, minor: 1, patch: 0)
        let appName = "Xcode_" + String(describing: version).replacingOccurrences(of: ".", with: "_") + ".app"
        return XcodeVersion(
            path: path.appendingPathComponent(appName, isDirectory: true),
            version: version,
            build: "11A1024"
        )
    }

}
