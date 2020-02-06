// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "xcutils",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcutils", targets: ["xcutils"]),
        .library(name: "TestRunner", targets: ["TestRunner"]),
        .library(name: "XcodeSelect", targets: ["XcodeSelect"]),
        .library(name: "VersionSpecifier", targets: ["VersionSpecifier"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "1.2.0"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["TestRunner", "XcodeSelect", "CLIHelpers"]),
        .testTarget(name: "xcutilsTests", dependencies: ["xcutils"]),

        .target(name: "TestRunner", dependencies: ["Version", "CLIHelpers"]),
        .testTarget(name: "TestRunnerTests", dependencies: ["TestRunner"]),

        .target(name: "XcodeSelect", dependencies: ["Version", "CLIHelpers"]),
        .testTarget(name: "XcodeSelectTests", dependencies: ["XcodeSelect"]),

        .target(name: "CLIHelpers"),
        .testTarget(name: "CLIHelpersTests", dependencies: ["CLIHelpers"]),

        .target(name: "VersionSpecifier", dependencies: ["Version"]),
        .testTarget(name: "VersionSpecifierTests", dependencies: ["VersionSpecifier"]),
    ]
)
