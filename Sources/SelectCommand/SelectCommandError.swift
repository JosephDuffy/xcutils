import struct Foundation.URL
import protocol Foundation.LocalizedError

public enum SelectCommandError: Error, LocalizedError, CustomStringConvertible {

    case foundNoVersions(path: URL)
    case printVersionsOrVersionSpecifierRequired

    public var localizedDescription: String {
        switch self {
        case .foundNoVersions(let path):
            return "Found no version at \(path.path)"
        case .printVersionsOrVersionSpecifierRequired:
            return "Either a version specifier or the --printVersions flag is required. See --help."
        }
    }

    public var description: String {
        return localizedDescription
    }

}
