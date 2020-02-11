public enum Platform: String, CaseIterable {

    case macOS

    case iOS

    case tvOS

    public init?(string: String) {
        for platform in Platform.allCases where string.lowercased() == platform.rawValue.lowercased() {
            self = platform
            return
        }

        return nil
    }
    
}
