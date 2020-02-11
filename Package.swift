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
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.0.1"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["SwiftToolsSupport", "TestCommand", "SelectCommand", "CLIHelpers"]),
        .testTarget(name: "xcutilsTests", dependencies: ["xcutils"]),

        .target(name: "TestCommand", dependencies: ["TestRunner", "SwiftToolsSupport"]),
        .testTarget(name: "TestCommandTests", dependencies: ["TestCommand"]),

        .target(name: "TestRunner", dependencies: ["Version", "VersionSpecifier", "CLIHelpers"]),
        .testTarget(name: "TestRunnerTests", dependencies: ["TestRunner"]),

        .target(name: "SelectCommand", dependencies: ["XcodeSelect", "SwiftToolsSupport"]),
        .testTarget(name: "SelectCommandTests", dependencies: ["SelectCommand"]),

        .target(name: "XcodeSelect", dependencies: ["Version", "VersionSpecifier", "CLIHelpers"]),
        .testTarget(name: "XcodeSelectTests", dependencies: ["XcodeSelect"]),

        .target(name: "CLIHelpers", dependencies: ["SwiftToolsSupport"]),
        .testTarget(name: "CLIHelpersTests", dependencies: ["CLIHelpers"]),

        .target(name: "VersionSpecifier", dependencies: ["Version", "SwiftToolsSupport"]),
        .testTarget(name: "VersionSpecifierTests", dependencies: ["VersionSpecifier"]),
    ]
)
