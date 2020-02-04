import XCTest
import class Foundation.Bundle

final class xcutilsTests: XCTestCase {
    func testNoSubcommand() throws {
        let fooBinary = productsDirectory.appendingPathComponent("xcutils")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "A subcommand is required\n")
        XCTAssertEqual(process.terminationStatus, 1)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }
}
