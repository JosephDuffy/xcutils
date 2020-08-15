// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "xcutils",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcutils", targets: ["xcutils"]),
        .library(name: "AppArchiver", targets: ["AppArchiver"]),
        .library(name: "TestRunner", targets: ["TestRunner"]),
        .library(name: "XcodeSelect", targets: ["XcodeSelect"]),
        .library(name: "VersionSpecifier", targets: ["VersionSpecifier"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["XcutilsCommand"]),

        .target(
            name: "XcutilsCommand",
            dependencies: [
                "ArchiveAppCommand",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "BuildCommand",
                "SelectCommand",
                "TestCommand",
            ]
        ),

        .target(name: "TestCommand", dependencies: ["TestRunner", .product(name: "ArgumentParser", package: "swift-argument-parser")]),

        .target(name: "TestRunner", dependencies: ["Models", "Version", "VersionSpecifier", "SimulatorControl", "CLIHelpers"]),

        .target(name: "AppArchiver", dependencies: ["CLIHelpers"]),

        .target(
            name: "ArchiveAppCommand",
            dependencies: [
                "AppArchiver",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "GlobalOptions",
            ]
        ),

        .target(name: "BuildCommand", dependencies: ["BuildRunner", .product(name: "ArgumentParser", package: "swift-argument-parser")]),

        .target(name: "BuildRunner", dependencies: ["Models", "Version", "VersionSpecifier", "SimulatorControl", "CLIHelpers"]),

        .target(
            name: "SelectCommand",
            dependencies: [
                "XcodeSelect",
                "GlobalOptions",
                "Models",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "SelectCommandTests",
            dependencies: [
                "SelectCommand",
                "TestFixtures",
                "XcodeSelect",
                "Version",
            ]
        ),

        .target(name: "XcodeSelect", dependencies: ["Version", "VersionSpecifier", "CLIHelpers"]),
        .testTarget(
            name: "XcodeSelectTests",
            dependencies: [
                "TestFixtures",
                "XcodeSelect",
                "Version",
            ]
        ),

        .target(name: "SimulatorControl", dependencies: ["CLIHelpers", "Models", "Version"]),

        .target(name: "GlobalOptions", dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),

        .target(name: "Models", dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),

        .target(name: "CLIHelpers", dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),

        .target(name: "TestFixtures", dependencies: ["XcodeSelect", "Version"], exclude: ["Xcodes"]),

        .target(name: "VersionSpecifier", dependencies: ["Version", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(name: "VersionSpecifierTests", dependencies: ["VersionSpecifier"]),
    ]
)
