import struct Version.Version

extension Array where Element == Version {

    public func findVersion(matching specifier: VersionSpecifier) -> Version? {
        switch specifier {
        case .latest:
            return stableReleases().sorted(by: >).first
        case .lastMajor:
            guard let latest = findVersion(matching: .latest) else { return nil }
            let lastMajor = latest.major - 1
            return filter { $0.major == lastMajor }.findVersion(matching: .latest)
        case .lastMinor:
            guard let latest = findVersion(matching: .latest) else { return nil }
            let lastMinor = latest.minor - 1
            return filter { $0.major == latest.major && $0.minor == lastMinor }.findVersion(matching: .latest)
        case .beta:
            return betaReleases().findVersion(matching: .latest)
        case .exact(let version):
            return first(where: { $0 == version })
        case .major(let major):
            return filter { $0.major == major }.findVersion(matching: .latest)
        case .majorMinor(let major, let minor):
            return filter { $0.major == major && $0.minor == minor }.findVersion(matching: .latest)
        }
    }

    public func stableReleases() -> [Version] {
        return filter { $0.prereleaseIdentifiers.isEmpty }
    }

    public func betaReleases() -> [Version] {
        return filter { $0.prereleaseIdentifiers.contains("beta") }
    }

}
