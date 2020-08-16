import AppArchiver
import CLIHelpers
import Foundation

public enum Notarizer {
    public enum Error: LocalizedError {
        /// An invalid file URL was provided. The URL must be to a .app, .xcarchive, or .zip.
        case invalidFileURL(URL)
        case outputDidNotContainJSON

        public var errorDescription: String? {
            switch self {
            case .invalidFileURL:
                return "File URL must be a .app, .xcarchive, or .zip."
            case .outputDidNotContainJSON:
                return "The output from altool did not contain JSON"
            }
        }
    }

    public enum Credentials {
        case username(_ username: String, password: String)
        case apiKey(_ apiKey: String, issuer: String)

        fileprivate func addToCommand(_ command: [String]) -> [String] {
            var command = command

            switch self {
            case .apiKey(let apiKey, let issuer):
                command.append(contentsOf: [
                    "--apiKey",
                    apiKey,
                    "--apiIssuer",
                    issuer,
                ])
            case .username(let username, let password):
                command.append(contentsOf: [
                    "--username",
                    username,
                    "--password",
                    password,
                ])
            }

            return command
        }
    }

    /**
     Notarize the app at the specified URL. If the URL is an app or xcarchive it will first be compressed in to a zip archive.

     - Parameters:
        - fileURL: The URL of the app to notarize.
        - credentials: The credentials to use to authenticate with the API.
        - primaryBundleId: The primary bundle identfier being notarized.
        - enableVerboseLogging: If `true` will output verbose logs. Defaults to `false`.
     - Returns: The notarization request UUID.
     */
    public static func notarizeApp(
        at fileURL: URL,
        credentials: Credentials,
        primaryBundleId: String,
        enableVerboseLogging: Bool = false
    ) throws -> String {
        if fileURL.path.hasSuffix(".zip") {
            return try notarizeArchive(
                at: fileURL,
                credentials: credentials,
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: enableVerboseLogging
            )
        } else if fileURL.path.hasSuffix(".app") || fileURL.path.hasSuffix(".xcarchive") {
            if enableVerboseLogging {
                print("App was provided, creating zip archive for uploading")
            }

            let zipURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString + ".zip", isDirectory: false)
            try AppArchiver.archiveApp(at: fileURL, outputTo: zipURL, enableVerboseLogging: enableVerboseLogging)
            return try notarizeArchive(
                at: zipURL,
                credentials: credentials,
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: enableVerboseLogging
            )
        } else {
            throw Error.invalidFileURL(fileURL)
        }
    }

    public static func getNotarizeInfo(
        notarizationUUID: String,
        credentials: Credentials,
        enableVerboseLogging: Bool = false
    ) throws -> NotarizationInfo {
        let unauthorisedCommand = [
            "xcrun",
            "altool",
            "--notarization-info",
            notarizationUUID,
            "--output-format",
            "json",
        ]

        let command = credentials.addToCommand(unauthorisedCommand)

        let outputData = try run(enableVerboseLogging: enableVerboseLogging, command)
        let jsonData = try self.jsonData(from: outputData)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(NotarizationInfo.self, from: jsonData)
    }

    private static func notarizeArchive(
        at archiveURL: URL,
        credentials: Credentials,
        primaryBundleId: String,
        enableVerboseLogging: Bool
    ) throws -> String {
        let unauthorisedCommand = [
            "xcrun",
            "altool",
            "--notarize-app",
            "--primary-bundle-id",
            primaryBundleId,
            "--file",
            archiveURL.path,
            "--output-format",
            "json",
        ]

        let command = credentials.addToCommand(unauthorisedCommand)

        let outputData = try run(enableVerboseLogging: enableVerboseLogging, command)
        let jsonData = try self.jsonData(from: outputData)

        let decoder = JSONDecoder()
        let output = try decoder.decode(NotarizeAppOutput.self, from: jsonData)

        return output.upload.requestUUID
    }

    /**
     Returns the JSON portion of the output data. `xcrun altool` will output the JWT when using API
     keys to authenticate and this used to remove that output.

     - Parameter outputData: The data output by the `xcrun altool` command.
     - Returns: The JSON portion of the data.
     */
    private static func jsonData(from outputData: Data) throws -> Data {
        /// `123` is the UTF8 codepoint for `{`
        let openingBrace = UInt8(123)
        let splitData = outputData.split(separator: openingBrace, maxSplits: 1, omittingEmptySubsequences: false)

        guard splitData.count == 2 else {
            throw Error.outputDidNotContainJSON
        }

        return Data([openingBrace]) + splitData[1]
    }
}

private struct NotarizeAppOutput: Codable {
    struct Upload: Codable {
        enum CodingKeys: String, CodingKey {
            case requestUUID = "RequestUUID"
        }

        let requestUUID: String
    }

    enum CodingKeys: String, CodingKey {
        case toolVersion = "tool-version"
        case toolPath = "tool-path"
        case upload = "notarization-upload"
        case successMessage = "success-message"
        case osVersion = "os-version"
    }

    let toolVersion: String
    let toolPath: String
    let upload: Upload
    let successMessage: String?
    let osVersion: String
}

public struct NotarizationInfo: Codable {
    public struct Info: Codable {
        public enum CodingKeys: String, CodingKey {
            case status = "Status"
            case statusMessage = "Status Message"
            case logFileURL = "LogFileURL"
            case date = "Date"
            case requestUUID = "RequestUUID"
            case statusCode = "Status Code"
            case hash = "Hash"
        }

        public enum Status: String, Codable {
            case success
            case inProgress = "in progress"
        }

        public let status: Status
        public let statusMessage: String?
        public let logFileURL: String?
        public let date: String
        public let requestUUID: String
        public let statusCode: Int?
        public let hash: String?
    }

    public enum CodingKeys: String, CodingKey {
        case toolVersion = "tool-version"
        case toolPath = "tool-path"
        case info = "notarization-info"
        case successMessage = "success-message"
        case osVersion = "os-version"
    }

    public let toolVersion: String
    public let toolPath: String
    public let info: Info
    public let successMessage: String?
    public let osVersion: String
}
