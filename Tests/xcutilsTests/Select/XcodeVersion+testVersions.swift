import struct XcodeSelect.XcodeVersion
import struct Version.Version

extension XcodeVersion {

    static var v11_1_gm: XcodeVersion {
        return XcodeVersion(
            version: Version(major: 11, minor: 1, patch: 0),
            build: "11A1024",
            isBeta: false
        )
    }

}
