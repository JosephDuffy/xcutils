// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "xcutils",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcutils", targets: ["xcutils"]),
        .library(name: "TestRunner", targets: ["TestRunner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["TestRunner", "CLIHelpers"]),
        .testTarget(name: "xcutilsTests", dependencies: ["xcutils"]),
        .target(name: "TestRunner", dependencies: ["Version", "CLIHelpers"]),
        .testTarget(name: "TestRunnerTests", dependencies: ["TestRunner"]),
        .target(name: "CLIHelpers"),
        .testTarget(name: "CLIHelpersTests", dependencies: ["CLIHelpers"]),
    ]
)
