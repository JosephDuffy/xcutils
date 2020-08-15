import XCTest
import Foundation
import VersionSpecifier
import struct Version.Version

final class VersionSpecifierTests: XCTestCase {

    func testInitialiser() {
        XCTAssertEqual(VersionSpecifier(rawValue: "latest"), .latest)
        XCTAssertEqual(VersionSpecifier(rawValue: "last-major"), .lastMajor)
        XCTAssertEqual(VersionSpecifier(rawValue: "last-minor"), .lastMinor)
        XCTAssertEqual(VersionSpecifier(rawValue: "beta"), .beta)
        XCTAssertEqual(VersionSpecifier(rawValue: "latest-beta"), .beta)
        XCTAssertEqual(VersionSpecifier(rawValue: "11"), .major(11))
        XCTAssertEqual(VersionSpecifier(rawValue: "11.3"), .majorMinor(11, 3))
        XCTAssertEqual(VersionSpecifier(rawValue: "11.3.0"), .exact(Version(11, 3, 0)))
        XCTAssertEqual(VersionSpecifier(rawValue: "12-beta"), .exact(Version(major: 12, minor: 0, patch: 0, prereleaseIdentifiers: ["beta"])))
        XCTAssertEqual(VersionSpecifier(rawValue: "12.1-beta"), .exact(Version(major: 12, minor: 1, patch: 0, prereleaseIdentifiers: ["beta"])))
        XCTAssertEqual(VersionSpecifier(rawValue: "12.2.1-beta"), .exact(Version(major: 12, minor: 2, patch: 1, prereleaseIdentifiers: ["beta"])))

        XCTAssertNil(VersionSpecifier(rawValue: "other"))
        XCTAssertNil(VersionSpecifier(rawValue: "11.3.a"))
        XCTAssertNil(VersionSpecifier(rawValue: "11.b"))
    }

}

