import enum TSCUtility.ShellCompletion
import protocol TSCUtility.ArgumentKind
import enum TSCUtility.ArgumentParserError

extension VersionSpecifier: ArgumentKind {

    public init(argument: String) throws {
        guard let versionSpecifier = VersionSpecifier(argument) else {
            throw ArgumentParserError.invalidValue(argument: argument, error: .unknown(value: argument))
        }

        self = versionSpecifier
    }

    public static var completion: ShellCompletion {
        // TODO: Convert to `function` and provide installed versions
        return .values([
            ("latest", "The latest version installed on the system"),
            ("last-major", "The latest last major version installed on the system"),
            ("last-minor", "The latest last minor version installed on the system"),
            ("beta", "The latest beta version installed on the system"),
        ])
    }


}
