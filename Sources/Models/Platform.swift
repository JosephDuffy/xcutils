import ArgumentParser

public enum Platform: String, RawRepresentable, ExpressibleByArgument, CaseIterable {

    case macOS

    case macCatalyst

    case iOS

    case tvOS

    case watchOS

    case visionOS

    public init?(rawValue string: String) {
        for platform in Platform.allCases where string.lowercased() == platform.rawValue.lowercased() {
            self = platform
            return
        }

        return nil
    }

}
