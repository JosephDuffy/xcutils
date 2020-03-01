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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["XcutilsCommand"]),

        .target(name: "XcutilsCommand", dependencies: ["ArgumentParser", "TestCommand", "SelectCommand"]),

        .target(name: "TestCommand", dependencies: ["TestRunner", "ArgumentParser"]),

        .target(name: "TestRunner", dependencies: ["Version", "VersionSpecifier", "CLIHelpers"]),

        .target(name: "SelectCommand", dependencies: ["XcodeSelect", "ArgumentParser"]),
        .testTarget(name: "SelectCommandTests", dependencies: ["SelectCommand"]),

        .target(name: "XcodeSelect", dependencies: ["Version", "VersionSpecifier", "CLIHelpers"]),

        .target(name: "CLIHelpers", dependencies: ["ArgumentParser"]),

        .target(name: "VersionSpecifier", dependencies: ["Version", "ArgumentParser"]),
        .testTarget(name: "VersionSpecifierTests", dependencies: ["VersionSpecifier"]),
    ]
)
