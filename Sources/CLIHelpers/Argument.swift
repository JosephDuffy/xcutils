import class Foundation.UserDefaults

public struct Argument {
    public let name: String
    public let shortName: String?
    
    public init(name: String, shortName: String? = nil) {
        self.name = name
        self.shortName = shortName
    }
    
    public func stringValue(userDefaults: UserDefaults = .standard) -> String? {
        return userDefaults.string(forKey: name) ??
            userDefaults.string(forKey: "-\(name)") ??
            shortName.flatMap(userDefaults.string(forKey:))
    }
}
