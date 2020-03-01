import XCTest
import Foundation
import XcodeSelect
import enum SelectCommand.SelectCommandError

final class XcodeSelectTests: XCTestCase {

    override func tearDown() {
        try? FileManager.default.removeItem(at: mockXcodesDirectory)
    }

    func testPrintVersionsWithASingleVersion() throws {
        let xcodeVersion = XcodeVersion.v11_1_gm(at: mockXcodesDirectory)
        try xcodeVersion.writeToPath()

        let binary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = binary
        process.arguments = [
            "select",
            "--search-path", "\(mockXcodesDirectory.path)",
            "--print-versions",
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "\(xcodeVersion.description)\n")
    }

    func testPrintVersionsWithNoVersions() throws {
        try FileManager.default.createDirectory(at: mockXcodesDirectory, withIntermediateDirectories: true, attributes: nil)
        let binary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = binary
        process.arguments = [
            "select",
            "--search-path", "\(mockXcodesDirectory.path)",
            "--print-versions",
        ]

        let standardErrorPipe = Pipe()
        process.standardError = standardErrorPipe

        try process.run()
        process.waitUntilExit()

        let standardErrorData = standardErrorPipe.fileHandleForReading.readDataToEndOfFile()
        let standardError = String(data: standardErrorData, encoding: .utf8)

        let status = process.terminationStatus

        XCTAssertEqual(status, 1, "Should exit with error status 1")
        let error = SelectCommandError.foundNoVersions(path: mockXcodesDirectory)
        XCTAssertEqual(standardError, "Error: \(error)\n")
    }

    var productURL: URL {
        return productsDirectory.appendingPathComponent("xcode-select-helper")
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

    var mockXcodesDirectory: URL {
        return testsDirectory.appendingPathComponent("Resources/MockXcodes", isDirectory: true)
    }

}
