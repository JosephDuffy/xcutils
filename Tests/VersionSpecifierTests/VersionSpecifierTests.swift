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

        XCTAssertNil(VersionSpecifier(rawValue: "other"))
        XCTAssertNil(VersionSpecifier(rawValue: "11.3.a"))
        XCTAssertNil(VersionSpecifier(rawValue: "11.b"))
    }

}

