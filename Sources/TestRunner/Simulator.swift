import struct Foundation.UUID

public struct Simulator: Codable {
    
    public enum State: String, Codable {
        case shutdown = "Shutdown"
        case booted = "Booted"
    }
    
    public let state: State
    public let isAvailable: Bool
    public let name: String
    public let udid: UUID
    public let availabilityError: String?
}
