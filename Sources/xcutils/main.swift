import func CLIHelpers.printError
import class TestRunner.TestRunner
import func Foundation.exit
import struct CLIHelpers.CommandError

guard CommandLine.arguments.count > 1 else {
    printError("At least 1 argument is required")
    exit(1)
}

let subCommand = CommandLine.arguments[1]

switch subCommand {
case "test":
    do {
        try TestRunner.runTests()
    } catch let error as CommandError {
        printError(error.message)
        exit(error.exitCode)
    } catch {
        printError(error)
        exit(1)
    }
default:
    printError("Unknown subcommand:", subCommand)
}
