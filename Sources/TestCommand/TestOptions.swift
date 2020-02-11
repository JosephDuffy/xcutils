import enum TestRunner.Platform
import enum VersionSpecifier.VersionSpecifier
import struct TSCBasic.AbsolutePath

struct TestOptions {
    var platform: Platform?
    var versionSpecifier: VersionSpecifier = .latest
    var projectPath: AbsolutePath?
    var scheme: String?
}

