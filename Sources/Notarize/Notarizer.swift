import AppArchiver
import CLIHelpers
import Foundation

public enum Notarizer {
    public enum Error: LocalizedError {
        /// An invalid file URL was provided. The URL must be to a .app or .zip.
        case invalidFileURL(URL)
        case outputDidNotContainJSON

        public var errorDescription: String? {
            switch self {
            case .invalidFileURL:
                return "File URL must be a .app or .zip."
            case .outputDidNotContainJSON:
                return "The output from altool did not contain JSON"
            }
        }
    }

    public enum Credentials {
        case username(_ username: String, password: String)
        case apiKey(_ apiKey: String, issuer: String)
    }

    /**
     Notarize the app at the specified URL. If the URL is an app it will first be compressed in to a zip archive.

     - Parameters:
       - fileURL: The URL of the app to notarize.
       - credentials: The credentials to use to authenticate with the API.
       - enableVerboseLogging: If `true` will output verbose logs. Defaults to `false`.
     */
    public static func notarizeApp(
        at fileURL: URL,
        credentials: Credentials,
        primaryBundleId: String,
        enableVerboseLogging: Bool = false
    ) throws {
        if fileURL.path.hasSuffix(".zip") {
            try notarizeArchive(
                at: fileURL,
                credentials: credentials,
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: enableVerboseLogging
            )
        } else if fileURL.path.hasSuffix(".app") {
            if enableVerboseLogging {
                print("App was provieded, creating zip archive for uploading")
            }

            let zipURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString + ".zip", isDirectory: false)
            try AppArchiver.archiveApp(at: fileURL, outputTo: zipURL, enableVerboseLogging: enableVerboseLogging)
            try notarizeArchive(
                at: zipURL,
                credentials: credentials,
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: enableVerboseLogging
            )
        } else {
            throw Error.invalidFileURL(fileURL)
        }
    }

    private static func notarizeArchive(
        at archiveURL: URL,
        credentials: Credentials,
        primaryBundleId: String,
        enableVerboseLogging: Bool
    ) throws {
        var command = [
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

        switch credentials {
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

        let outputData = try run(enableVerboseLogging: enableVerboseLogging, command)

        /// `123` is the UTF8 codepoint for `{`
        let openingBrace = UInt8(123)
        let splitData = outputData.split(separator: openingBrace, maxSplits: 1, omittingEmptySubsequences: false)

        guard splitData.count == 2 else {
            throw Error.outputDidNotContainJSON
        }
        let jsonData = Data([openingBrace]) + splitData[1]
        let decoder = JSONDecoder()
        let output = try decoder.decode(NotarizeAppOutput.self, from: jsonData)

        print(output.upload.requestUUID)
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
