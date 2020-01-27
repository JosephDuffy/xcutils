import struct Version.Version

public typealias SemanticVersion = Version

public struct Platform {
    
    public enum Version {
        case latest
        case specific(SemanticVersion)
    }
    
    public let name: String
    
    public let version: Version
    
    public init?(name: String, version: String) {
        self.name = name
        
        if version == "latest" {
            self.version = .latest
        } else if let version = SemanticVersion(tolerant: version) {
            self.version = .specific(version)
        } else {
            return nil
        }
    }
    
}
