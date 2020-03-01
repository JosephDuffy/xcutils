import protocol Foundation.LocalizedError

public enum TestCommandError: Swift.Error, LocalizedError, CustomStringConvertible {

    case schemeRequired
    case projectRequired

    public var localizedDescription: String {
        switch self {
        case .schemeRequired:
            return "A scheme must be specified"
        case .projectRequired:
            return "A project must be specified"
        }
    }

    public var description: String {
        return localizedDescription
    }
    
}
