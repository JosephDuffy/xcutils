import Foundation

public final class XcodeSelect {
    
    public static func findVersions(in directory: URL) throws -> [XcodeVersion] {
        let xcodePaths = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: []
        ).filter { $0.lastPathComponent.starts(with: "Xcode") && $0.hasDirectoryPath }
        return xcodePaths.compactMap(XcodeVersion.init(url:))
    }
    
}
