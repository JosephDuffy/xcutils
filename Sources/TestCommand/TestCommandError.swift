import protocol Foundation.LocalizedError

public enum TestCommandError: Swift.Error, LocalizedError {
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
}
