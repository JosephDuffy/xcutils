import Foundation
import TestFixtures
import Version
import XcodeSelect
import XCTest

final class XcodeVersionTests: XCTestCase {
    func testVersionSorting() throws {
        let xcodeVersions = try TestFixtures.allXcodeFixtures.map { try XcodeVersion(url: $0) }.sorted()
        let expectedVersions = [
            TestFixtures.xcodeVersion_8_3,
            TestFixtures.xcodeVersion_9_4_1,
            TestFixtures.xcodeVersion_10_0,
            TestFixtures.xcodeVersion_10_3,
            TestFixtures.xcodeVersion_11_1,
            TestFixtures.xcodeVersion_11_2_beta,
            TestFixtures.xcodeVersion_11_2_1,
            TestFixtures.xcodeVersion_11_3_beta1,
            TestFixtures.xcodeVersion_11_3,
            TestFixtures.xcodeVersion_11_3_1,
            TestFixtures.xcodeVersion_11_4_beta1,
            TestFixtures.xcodeVersion_11_4_beta2,
            TestFixtures.xcodeVersion_11_4_beta3,
            TestFixtures.xcodeVersion_11_4,
            TestFixtures.xcodeVersion_11_4_1,
            TestFixtures.xcodeVersion_11_5_beta,
            TestFixtures.xcodeVersion_11_5,
            TestFixtures.xcodeVersion_11_6_beta1,
            TestFixtures.xcodeVersion_11_6,
            TestFixtures.xcodeVersion_12_beta,
            TestFixtures.xcodeVersion_12_beta2,
            TestFixtures.xcodeVersion_12_beta3,
            TestFixtures.xcodeVersion_12_beta4,
            TestFixtures.xcodeVersion_12_beta5,
            TestFixtures.xcodeVersion_12_beta6,
            TestFixtures.xcodeVesion_12_gm_12A7208,
            TestFixtures.xcodeVesion_12_gm_12A7209,
            TestFixtures.xcodeVersion_12_2_beta,
        ]
        XCTAssertEqual(xcodeVersions, expectedVersions)
    }

    func testVersionParsing() throws {
        for xcodeFixture in TestFixtures.allXcodeFixtures {
            _ = try XcodeVersion(url: xcodeFixture)
        }
    }
}
