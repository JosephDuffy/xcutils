import Foundation

public struct CommandError: Error {
    public let message: String
    public let exitCode: Int32
}

public func run(enableVerboseLogging: Bool = false, _ command: String...) throws -> Data {
    return try run(enableVerboseLogging: enableVerboseLogging, command)
}

public func run(enableVerboseLogging: Bool = false, _ command: [String]) throws -> Data {
    let pipe = Pipe()
    try run(enableVerboseLogging: enableVerboseLogging, command, streamOutputTo: .pipe(pipe))
    return pipe.fileHandleForReading.readDataToEndOfFile()
}

public enum CommandOutput {
    case standardOut
    case pipe(Pipe)
}

public func run(enableVerboseLogging: Bool = false, _ command: [String], streamOutputTo output: CommandOutput) throws {
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = command

    switch output {
    case .pipe(let pipe):
        process.standardOutput = pipe
    case .standardOut:
        break
    }
    let standardError = Pipe()
    process.standardError = standardError

    if enableVerboseLogging {
        print("Running command", command.joined(separator: " "))
    }

    try process.run()
    process.waitUntilExit()

    if process.terminationStatus != 0 {
        let errorData = standardError.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errorData, encoding: .utf8)!
        let output = (
                (process.standardOutput as? Pipe)?
                .fileHandleForReading
                .readDataToEndOfFile()
            )
            .flatMap { data in
                String(data: data, encoding: .utf8)
            }

        if enableVerboseLogging {
            print("Termination status \(process.terminationStatus)")
            if let output = output {
                print("Output: \(output)")
            }
        }
        throw CommandError(message: error.isEmpty ? output ?? "" : error, exitCode: process.terminationStatus)
    }
}
