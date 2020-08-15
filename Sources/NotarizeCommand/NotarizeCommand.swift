import Foundation
import Notarize
import ArgumentParser
import GlobalOptions

public struct NotarizeCommand: ParsableCommand {
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

        switch (username, password, apiKey, apiIssuer) {
        case (.some(let username), .some(let password), _, _):
            try Notarizer.notarizeApp(
                at: fileURL,
                credentials: .username(username, password: password),
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: globalOptions.verbose
            )
        case (_, _, .some(let apiKey), .some(let apiIssuer)):
            try Notarizer.notarizeApp(
                at: fileURL,
                credentials: .apiKey(apiKey, issuer: apiIssuer),
                primaryBundleId: primaryBundleId,
                enableVerboseLogging: globalOptions.verbose
            )
        default:
            throw ValidationError("Either --username and --password or --api-key and --api-issuer are required")
        }
    }
}
