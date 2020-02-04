import func CLIHelpers.printError
import class TestRunner.TestRunner
import func Foundation.exit
import struct CLIHelpers.CommandError
import struct Foundation.URL
import class XcodeSelect.XcodeSelect
import Foundation

guard CommandLine.arguments.count > 1 else {
    printError("A subcommand is required")
    exit(1)
}

let subCommand = CommandLine.arguments[1]

do {
    switch subCommand {
    case "test":
        try TestRunner.runTests()
    case "select":
        let searchPath: URL
        if let searchPathString = SelectCommandLineArguments.searchPath.stringValue() {
            searchPath = URL(fileURLWithPath: searchPathString, isDirectory: true).standardizedFileURL
        } else {
            searchPath = URL(string: "/Applications")!
        }

        let doPrintVersions = CommandLine.arguments.contains("--printVersions")

        do {
            let versions = try XcodeSelect.findVersions(in: searchPath)

            guard !versions.isEmpty else {
                printError("Failed to find any Xcode versions at", searchPath.path)
                exit(1)
            }

            if doPrintVersions {
                let versionDescriptions = versions.map(String.init(describing:))
                let versionsList = versionDescriptions.joined(separator: "\n")
                print(versionsList)
            }
        } catch {
            printError("Error finding versions at \(searchPath):", error)
            exit(1)
        }
    default:
        printError("Unknown subcommand:", subCommand)
    }
} catch let error as CommandError {
    printError(error.message)
    exit(error.exitCode)
} catch {
    printError(error)
    exit(1)
}
