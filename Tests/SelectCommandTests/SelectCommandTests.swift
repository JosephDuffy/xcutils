import XCTest
import Foundation
import TestFixtures
import XcodeSelect
import SelectCommand

final class SelectCommandTests: XCTestCase {
    override func setUpWithError() throws {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = [
            "mdimport",
            TestFixtures.xcodesURL.path,
        ]

        try process.run()
        process.waitUntilExit()
    }

    func _testPrintVersionsWithSpotlightCache() throws {
        let binary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = binary
        process.arguments = [
            "select",
            "--search-path", TestFixtures.xcodesURL.path,
            "--print-versions",
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        let expectedOutput = TestFixtures.allXcodeVersions.sorted(by: >).map(\.description).joined(separator: "\n") + "\n"

        XCTAssertEqual(output, expectedOutput)
    }

    func testPrintVersionsWithoutSpotlightCache() throws {
        let binary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = binary
        process.arguments = [
            "select",
            "--search-path", TestFixtures.xcodesURL.path,
            "--print-versions",
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        let expectedOutput = TestFixtures.allXcodeVersions.sorted(by: >).map(\.description).joined(separator: "\n") + "\n"

        XCTAssertEqual(output, expectedOutput)
    }

    func testPrintVersionsWithNoVersions() throws {
        let rootURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let binary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = binary
        process.arguments = [
            "select",
            "--search-path", "\(rootURL.path)",
            "--print-versions",
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Found no version at \(rootURL.path)")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        return testsDirectory.deletingLastPathComponent()
    }

    var testsDirectory: URL {
        return testsBundle.bundleURL
    }

    var testsBundle: Bundle {
        return Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".xctest") })!
    }
}
