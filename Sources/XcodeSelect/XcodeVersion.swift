import Foundation
import Version

public struct XcodeVersion: Comparable, CustomStringConvertible, Codable {
    public static func < (lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        if lhs.version == rhs.version {
            if lhs.isBeta && !rhs.isBeta {
                return true
            }

            // The build is usually in the format {major-version}{single-letter}{number}, sometimes
            // with another single character on the end. This is a crude way to attempt to parse
            // this and will need to be tested with more versions.
            let majorVersionString = "\(lhs.version.major)"
            if lhs.build.starts(with: majorVersionString) && rhs.build.starts(with: majorVersionString) {
                var lhsBuild = lhs.build
                var rhsBuild = rhs.build
                lhsBuild = String(lhsBuild.dropFirst(majorVersionString.count))
                rhsBuild = String(rhsBuild.dropFirst(majorVersionString.count))

                enum SearchMode {
                    case letters
                    case numbers
                }

                var searchMode: SearchMode = .letters

                outerWhile: while !lhsBuild.isEmpty && !rhsBuild.isEmpty {
                    let predicate = { (character: Character) -> Bool in
                        switch searchMode {
                        case .letters:
                            return character.isLetter
                        case .numbers:
                            return character.isNumber
                        }
                    }

                    let lhsCharacters = lhsBuild.prefix(while: predicate)
                    let rhsCharacters = rhsBuild.prefix(while: predicate)

                    defer {
                        lhsBuild = String(lhsBuild.dropFirst(lhsCharacters.count))
                        rhsBuild = String(rhsBuild.dropFirst(rhsCharacters.count))
                    }

                    switch searchMode {
                    case .letters:
                        defer {
                            searchMode = .numbers
                        }

                        guard lhsCharacters.count == rhsCharacters.count else { break outerWhile }

                        for (index, lhsCharacter) in lhsCharacters.enumerated() {
                            let rhsCharacter = rhsCharacters[rhsCharacters.index(rhsCharacters.startIndex, offsetBy: index)]

                            if rhsCharacter == lhsCharacter { continue }

                            return lhsCharacter < rhsCharacter
                        }
                    case .numbers:
                        defer {
                            searchMode = .letters
                        }

                        guard let lhsNumber = Int(lhsCharacters), let rhsNumber = Int(rhsCharacters) else { break outerWhile }

                        if lhsNumber == rhsNumber { continue }

                        return lhsNumber < rhsNumber
                    }
                }
            }

            // This is not always accurate (e.g. Xcode 12 beta 1 vs Xcode 12 beta 2), but hopefully
            // this is never reached.
            return lhs.bundleVersion < rhs.bundleVersion
        } else {
            return lhs.version < rhs.version
        }
    }

    public let path: URL
    public let version: Version
    public let bundleVersion: Float
    public let build: String
    public var isBeta: Bool {
        return version.prereleaseIdentifiers.contains("beta")
    }
    
    public var description: String {
        return "Xcode \(version) (\(build)) at \(path.path)"
    }

    public init(path: URL, version: Version, bundleVersion: Float, build: String) {
        self.path = path
        self.version = version
        self.bundleVersion = bundleVersion
        self.build = build
    }
    
}

extension XcodeVersion {
    public enum URLInitError: Error {
        case missingInfoPlist
        case missingVersionPlist
        case decodeError(Error)
    }

    public init(url: URL) throws {
        path = url

        let decoder = PropertyListDecoder()
        decoder.userInfo[.decodingMethod] = DecodingMethod.tolerant
        let infoPlistURL = url.appendingPathComponent("Contents/Info.plist", isDirectory: false)
        let versionPlistURL = url.appendingPathComponent("Contents/version.plist", isDirectory: false)

        guard let infoPlistData = FileManager.default.contents(atPath: infoPlistURL.path) else {
            throw URLInitError.missingInfoPlist
        }
        guard let versionPlistData = FileManager.default.contents(atPath: versionPlistURL.path) else {
            throw URLInitError.missingVersionPlist
        }

        var format = PropertyListSerialization.PropertyListFormat.binary
        let infoPlist = try decoder.decode(XcodeInfoPlist.self, from: infoPlistData, format: &format)
        let versionPlist = try decoder.decode(XcodeVersionPlist.self, from: versionPlistData, format: &format)

        if infoPlist.iconFileName.hasSuffix("Beta") {
            version = Version(
                major: versionPlist.version.major,
                minor: versionPlist.version.minor,
                patch: versionPlist.version.patch,
                prereleaseIdentifiers: versionPlist.version.prereleaseIdentifiers + ["beta"],
                buildMetadataIdentifiers: versionPlist.version.buildMetadataIdentifiers
            )
        } else {
            version = versionPlist.version
        }

        bundleVersion = versionPlist.bundleVersion
        build = versionPlist.build
    }
}
