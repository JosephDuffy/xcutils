import class Foundation.Process
import class Foundation.Pipe
import struct Foundation.Data
import class Foundation.NotificationCenter
import protocol Foundation.NSObjectProtocol
import struct Foundation.Notification

public struct CommandError: Error {
    public let message: String
    public let exitCode: Int32
}

public func run(_ command: String...) throws -> Data {
    let pipe = Pipe()
    try run(command, streamOutputTo: pipe)
    return pipe.fileHandleForReading.readDataToEndOfFile()
}

public func run(_ command: [String], streamOutputTo outputPipe: Pipe? = nil) throws {
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = command

    outputPipe.map { process.standardOutput = $0 }
    let standardError = Pipe()
    process.standardError = standardError

    try process.run()
    process.waitUntilExit()

    if process.terminationStatus != 0 {
        let errorData = standardError.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errorData, encoding: .utf8)!
        throw CommandError(message: error, exitCode: process.terminationStatus)
    }
}
