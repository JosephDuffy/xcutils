import func CLIHelpers.printError
import class TestRunner.TestRunner
import func Foundation.exit
import struct CLIHelpers.CommandError
import struct Foundation.URL
import class SelectCommand.SelectCommand

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
        try SelectCommand.run(args: Array(CommandLine.arguments.dropFirst(2)))
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
