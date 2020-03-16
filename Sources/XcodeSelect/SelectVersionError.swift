import protocol Foundation.LocalizedError
import enum VersionSpecifier.VersionSpecifier

public enum SelectVersionError: Error, LocalizedError, CustomStringConvertible {

    case noVersionMatchingSpecifier(VersionSpecifier)
    case requiresRoot

    public var errorDescription: String? {
        switch self {
        case .noVersionMatchingSpecifier(let versionSpecifier):
            return "No version found matching \(versionSpecifier)"
        case .requiresRoot:
            return "The select subcommand must be run as root: `sudo xcutils select <version-specifier>"
        }
    }

    public var description: String {
        return localizedDescription
    }

}
