import XCTest
import Foundation
import VersionSpecifier
import struct Version.Version

final class VersionSpecifierTests: XCTestCase {

    func testInitialiser() {
        XCTAssertEqual(VersionSpecifier("latest"), .latest)
        XCTAssertEqual(VersionSpecifier("last-major"), .lastMajor)
        XCTAssertEqual(VersionSpecifier("last-minor"), .lastMinor)
        XCTAssertEqual(VersionSpecifier("beta"), .beta)
        XCTAssertEqual(VersionSpecifier("latest-beta"), .beta)
        XCTAssertEqual(VersionSpecifier("11"), .major(11))
        XCTAssertEqual(VersionSpecifier("11.3"), .majorMinor(11, 3))
        XCTAssertEqual(VersionSpecifier("11.3.0"), .exact(Version(11, 3, 0)))

        XCTAssertNil(VersionSpecifier("other"))
        XCTAssertNil(VersionSpecifier("11.3.a"))
        XCTAssertNil(VersionSpecifier("11.b"))
    }

}

