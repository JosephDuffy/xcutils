import struct Version.Version
import ArgumentParser

public enum VersionSpecifier: RawRepresentable, ExpressibleByArgument, Equatable {
    
    /// The latest stable version
    case latest
    
    /// The last major stable version
    case lastMajor

    /// The last minor stable version
    case lastMinor
    
    /// The latest beta release
    case beta
    
    /// An exact version
    case exact(Version)

    case major(Int)

    case majorMinor(_ major: Int, _ minor: Int)

    public var rawValue: String {
        switch self {
        case .latest:
            return "latest"
        case .lastMajor:
            return "last-major"
        case .lastMinor:
            return "last-minor"
        case .beta:
            return "beta"
        case .exact(let version):
            return String(describing: version)
        case .major(let major):
            return "\(major)"
        case .majorMinor(let major, let minor):
            return "\(major).\(minor)"
        }
    }
    
    public init?(rawValue string: String) {
        switch string {
        case "latest":
            self = .latest
        case "last-major":
            self = .lastMajor
        case "last-minor":
            self = .lastMinor
        case "beta", "latest-beta":
            self = .beta
        default:
            guard let version = Version(tolerant: string) else { return nil }

            let prereleaseStartIndex = string.firstIndex(of: "-")
            let metadataStartIndex = string.firstIndex(of: "+")
            let requiredEndIndex = prereleaseStartIndex ?? metadataStartIndex ?? string.endIndex
            let requiredCharacters = string.prefix(upTo: requiredEndIndex)
            let splits = requiredCharacters.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: false)

            switch splits.count {
            case 1:
                self = .major(version.major)
            case 2:
                self = .majorMinor(version.major, version.minor)
            default:
                self = .exact(version)
            }
        }
    }
    
}
