import Foundation

public struct SDK: Codable {
    public let buildID: String?
    public let canonicalName: String
    public let displayName: String
    public let isBaseSdk: Bool
    public let platform: String
    public let platformPath: URL
    public let platformVersion: String
    public let productBuildVersion: String?
    public let productCopyright: String?
    public let productName: String?
    public let productVersion: String?
    public let sdkPath: URL
    public let sdkVersion: String
}
