import struct Foundation.URL
import protocol Foundation.LocalizedError

public enum SelectCommandError: Error, LocalizedError {
    case foundNoVersions(path: URL)

    public var localizedDescription: String {
        switch self {
        case .foundNoVersions(let path):
            return "Found no version at \(path.path)"
        }
    }

}
