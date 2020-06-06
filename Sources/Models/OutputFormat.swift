import ArgumentParser

public enum OutputFormat: String, RawRepresentable, ExpressibleByArgument, CaseIterable {

    case humanFriendly

    case json

}
