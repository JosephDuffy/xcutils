import Foundation
import Notarize
import ArgumentParser
import GlobalOptions

public struct NotarizeCommand: ParsableCommand {
    public enum WaitForCompletionError: LocalizedError {
        case waitTimedOut

        public var errorDescription: String? {
            switch self {
            case .waitTimedOut:
                return "Timed out while waiting for completion."
            }
        }
    }

    public static var configuration = CommandConfiguration(
        commandName: "notarize",
        abstract: "Notarize macOS apps."
    )

    @Argument()
    var filePath: String

    @Option
    var primaryBundleId: String

    @Option
    var username: String?

    @Option
    var password: String?

    @Option
    var apiKey: String?

    @Option
    var apiIssuer: String?

    @Flag
    var waitForCompletion: Bool = false

    @Option(
        help: ArgumentHelp(
            "The timeout (in seconds) to wait for completion.",
            discussion: "A value of zero denotes no timeout."
        )
    )
    var completionTimeout: TimeInterval = 0

    @Option(help: "The frequency to check for completion (in seconds).")
    var completionCheckFrequency: UInt32 = 15

    @OptionGroup()
    var globalOptions: GlobalOptions

    public init() {}

    public func validate() throws {
        switch (username, password, apiKey, apiIssuer) {
        case (.some, .some, nil, nil), (nil, nil, .some, .some):
            break
        case (.some, nil, _, _):
            throw ValidationError("--password must be provided when --username is provided")
        case (nil, .some, _, _):
            throw ValidationError("--username must be provided when --password is provided")
        case (_, _, .some, nil):
            throw ValidationError("--api-issuer must be provided when --api-key is provided")
        case (_, _, nil, .some):
            throw ValidationError("--api-key must be provided when --api-issuer is provided")
        default:
            throw ValidationError("Either --username and --password or --api-key and --api-issuer are required")
        }
    }

    public func run() throws {
        let fileURL = URL(fileURLWithPath: filePath)
        let credentials: Notarizer.Credentials

        switch (username, password, apiKey, apiIssuer) {
        case (.some(let username), .some(let password), _, _):
            credentials = .username(username, password: password)
        case (_, _, .some(let apiKey), .some(let apiIssuer)):
            credentials = .apiKey(apiKey, issuer: apiIssuer)
        default:
            throw ValidationError("Either --username and --password or --api-key and --api-issuer are required")
        }

        let requestUUID = try Notarizer.notarizeApp(
            at: fileURL,
            credentials: credentials,
            primaryBundleId: primaryBundleId,
            enableVerboseLogging: globalOptions.verbose
        )

        if waitForCompletion {
            print("Notarization UUID: \(requestUUID). Checking status...")
            checkNotarizationStatus(requestUUID: requestUUID, credentials: credentials)
        } else {
            print("Notarization request completed. Request UUID: \(requestUUID)")
        }
    }

    private func checkNotarizationStatus(
        requestUUID: String,
        credentials: Notarizer.Credentials,
        checkStart: Date = Date()
    ) {
        do {
            let notarizationInfo = try Notarizer
                .getNotarizeInfo(
                    notarizationUUID: requestUUID,
                    credentials: credentials,
                    enableVerboseLogging: globalOptions.verbose
                )

            switch notarizationInfo.info.status {
            case .success:
                print(notarizationInfo.info.statusMessage ?? "Notarization was accepted")
                if let logFileURL = notarizationInfo.info.logFileURL {
                    print("Log available at: \(logFileURL)")
                }
            case .inProgress:
                if completionTimeout > 0 {
                    let now = Date()
                    let elapsedTime = now.timeIntervalSince(checkStart)

                    guard (elapsedTime + TimeInterval(completionCheckFrequency)) < completionTimeout else {
                        throw WaitForCompletionError.waitTimedOut
                    }
                }

                print("Notarization in progress. Checking again in \(completionCheckFrequency) second\(completionCheckFrequency == 1 ? "" : "s")...")

                sleep(completionCheckFrequency)
                checkNotarizationStatus(requestUUID: requestUUID, credentials: credentials, checkStart: checkStart)
            }
        } catch {
            NotarizeCommand.exit(withError: error)
        }
    }
}
