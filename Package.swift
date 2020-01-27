// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "xcutils",
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "xcutils", dependencies: ["Version"]),
        .testTarget(name: "xcutilsTests", dependencies: ["xcutils"]),
    ]
)
