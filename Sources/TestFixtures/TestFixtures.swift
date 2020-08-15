import Foundation
import XcodeSelect
import Version

public enum TestFixtures {
    public static var allXcodeFixtures: [URL] {
        [
            xcodeFixture_9_4_1,
            xcodeFixture_10_0,
            xcodeFixture_10_3,
            xcodeFixture_11_1,
            xcodeFixture_11_2_beta,
            xcodeFixture_11_2_1,
            xcodeFixture_11_3_beta1,
            xcodeFixture_11_3,
            xcodeFixture_11_3_1,
            xcodeFixture_11_4_beta1,
            xcodeFixture_11_4_beta2,
            xcodeFixture_11_4_beta3,
            xcodeFixture_11_4,
            xcodeFixture_11_4_1,
            xcodeFixture_11_5_beta,
            xcodeFixture_11_5,
            xcodeFixture_11_6,
            xcodeFixture_11_6_beta1,
            xcodeFixture_12_beta,
            xcodeFixture_12_beta2,
            xcodeFixture_12_beta3,
            xcodeFixture_12_beta4,
        ]
    }
    public static var xcodeFixture_9_4_1: URL {
        url(forXcodeVersion: "9.4.1")
    }
    public static var xcodeFixture_10_0: URL {
        url(forXcodeVersion: "10.0")
    }
    public static var xcodeFixture_10_3: URL {
        url(forXcodeVersion: "10.3")
    }
    public static var xcodeFixture_11_1: URL {
        url(forXcodeVersion: "11.1")
    }
    public static var xcodeFixture_11_2_beta: URL {
        url(forXcodeVersion: "11.2-beta")
    }
    public static var xcodeFixture_11_2_1: URL {
        url(forXcodeVersion: "11.2.1")
    }
    public static var xcodeFixture_11_3_beta1: URL {
        url(forXcodeVersion: "11.3-beta")
    }
    public static var xcodeFixture_11_3: URL {
        url(forXcodeVersion: "11.3")
    }
    public static var xcodeFixture_11_3_1: URL {
        url(forXcodeVersion: "11.3.1")
    }
    public static var xcodeFixture_11_4_beta1: URL {
        url(forXcodeVersion: "11.4-beta")
    }
    public static var xcodeFixture_11_4_beta2: URL {
        url(forXcodeVersion: "11.4-beta2")
    }
    public static var xcodeFixture_11_4_beta3: URL {
        url(forXcodeVersion: "11.4-beta3")
    }
    public static var xcodeFixture_11_4: URL {
        url(forXcodeVersion: "11.4")
    }
    public static var xcodeFixture_11_4_1: URL {
        url(forXcodeVersion: "11.4.1")
    }
    public static var xcodeFixture_11_5_beta: URL {
        url(forXcodeVersion: "11.5-beta")
    }
    public static var xcodeFixture_11_5: URL {
        url(forXcodeVersion: "11.5")
    }
    public static var xcodeFixture_11_6: URL {
        url(forXcodeVersion: "11.6")
    }
    public static var xcodeFixture_11_6_beta1: URL {
        url(forXcodeVersion: "11.6-beta")
    }
    public static var xcodeFixture_12_beta: URL {
        url(forXcodeVersion: "12-beta")
    }
    public static var xcodeFixture_12_beta2: URL {
        url(forXcodeVersion: "12-beta2")
    }
    public static var xcodeFixture_12_beta3: URL {
        url(forXcodeVersion: "12-beta3")
    }
    public static var xcodeFixture_12_beta4: URL {
        url(forXcodeVersion: "12-beta4")
    }
    public static var allXcodeVersions: [XcodeVersion] {
        [
            xcodeVersion_9_4_1,
            xcodeVersion_10_0,
            xcodeVersion_10_3,
            xcodeVersion_11_1,
            xcodeVersion_11_2_beta,
            xcodeVersion_11_2_1,
            xcodeVersion_11_3_beta1,
            xcodeVersion_11_3,
            xcodeVersion_11_3_1,
            xcodeVersion_11_4_beta1,
            xcodeVersion_11_4_beta2,
            xcodeVersion_11_4_beta3,
            xcodeVersion_11_4,
            xcodeVersion_11_4_1,
            xcodeVersion_11_5_beta,
            xcodeVersion_11_5,
            xcodeVersion_11_6,
            xcodeVersion_11_6_beta1,
            xcodeVersion_12_beta,
            xcodeVersion_12_beta2,
            xcodeVersion_12_beta3,
            xcodeVersion_12_beta4,
        ]
    }
    public static var xcodeVersion_9_4_1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_9_4_1,
            version: Version(9, 4, 1),
            bundleVersion: 14161,
            build: "9F2000"
        )
    }
    public static var xcodeVersion_10_0: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_10_0,
            version: Version(10, 0, 0),
            bundleVersion: 14320.25,
            build: "10A255"
        )
    }
    public static var xcodeVersion_10_3: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_10_3,
            version: Version(10, 3, 0),
            bundleVersion: 14492.2,
            build: "10G8"
        )
    }
    public static var xcodeVersion_11_1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_1,
            version: Version(11, 1, 0),
            bundleVersion: 15405,
            build: "11A1027"
        )
    }
    public static var xcodeVersion_11_2_beta: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_2_beta,
            version: Version(major: 11, minor: 2, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 15519,
            build: "11B44"
        )
    }
    public static var xcodeVersion_11_2_1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_2_1,
            version: Version(11, 2, 1),
            bundleVersion: 15526.1,
            build: "11B500"
        )
    }
    public static var xcodeVersion_11_3_beta1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_3_beta1,
            version: Version(major: 11, minor: 3, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 15710,
            build: "11C24b"
        )
    }
    public static var xcodeVersion_11_3: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_3,
            version: Version(11, 3, 0),
            bundleVersion: 15712,
            build: "11C29"
        )
    }
    public static var xcodeVersion_11_3_1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_3_1,
            version: Version(11, 3, 1),
            bundleVersion: 15715,
            build: "11C505"
        )
    }
    public static var xcodeVersion_11_4_beta1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_4_beta1,
            version: Version(major: 11, minor: 4, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 16118.3,
            build: "11N111s"
        )
    }
    public static var xcodeVersion_11_4_beta2: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_4_beta2,
            version: Version(major: 11, minor: 4, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 16126.2,
            build: "11N123k"
        )
    }
    public static var xcodeVersion_11_4_beta3: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_4_beta3,
            version: Version(major: 11, minor: 4, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 16132.1,
            build: "11N132i"
        )
    }
    public static var xcodeVersion_11_4: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_4,
            version: Version(11, 4, 0),
            bundleVersion: 16134.0,
            build: "11E146"
        )
    }
    public static var xcodeVersion_11_4_1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_4_1,
            version: Version(11, 4, 1),
            bundleVersion: 16137.0,
            build: "11E503a"
        )
    }
    public static var xcodeVersion_11_5_beta: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_5_beta,
            version: Version(major: 11, minor: 5, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 16139,
            build: "11N605c"
        )
    }
    public static var xcodeVersion_11_5: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_5,
            version: Version(11, 5, 0),
            bundleVersion: 16139,
            build: "11E608c"
        )
    }
    public static var xcodeVersion_11_6_beta1: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_6_beta1,
            version: Version(major: 11, minor: 6, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 16140,
            build: "11N700h"
        )
    }
    public static var xcodeVersion_11_6: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_11_6,
            version: Version(11, 6, 0),
            bundleVersion: 16141,
            build: "11E708"
        )
    }
    public static var xcodeVersion_12_beta: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_12_beta,
            version: Version(major: 12, minor: 0, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 17177,
            build: "12A6159"
        )
    }
    public static var xcodeVersion_12_beta2: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_12_beta2,
            version: Version(major: 12, minor: 0, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 17175.2,
            build: "12A6163b"
        )
    }
    public static var xcodeVersion_12_beta3: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_12_beta3,
            version: Version(major: 12, minor: 0, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 17189.4,
            build: "12A8169g"
        )
    }
    public static var xcodeVersion_12_beta4: XcodeVersion {
        XcodeVersion(
            path: xcodeFixture_12_beta4,
            version: Version(major: 12, minor: 0, patch: 0, prereleaseIdentifiers: ["beta"]),
            bundleVersion: 17200.1,
            build: "12A8179i"
        )
    }

    public static var xcodesURL: URL {
        url(forResource: "Xcodes", isDirectory: true)
    }

    public static func url(
        forResource filename: String,
        isDirectory: Bool? = nil,
        inDirectory directory: String? = nil,
        relativeTo basePath: String = #file
    ) -> URL {
        let baseURL = URL(fileURLWithPath: basePath)
        var fixtureURL = URL(fileURLWithPath: ".", relativeTo: baseURL)
        directory.map { fixtureURL.appendPathComponent($0, isDirectory: true) }

        if let isDirectory = isDirectory {
            fixtureURL.appendPathComponent(filename, isDirectory: isDirectory)
        } else {
            fixtureURL.appendPathComponent(filename)
        }

        return fixtureURL
    }

    public static func url(
        forXcodeVersion xcodeVersion: String,
        relativeTo basePath: String = #file
    ) -> URL {
        url(forResource: "Xcode_\(xcodeVersion).app", isDirectory: true, inDirectory: "Xcodes")
    }
}
