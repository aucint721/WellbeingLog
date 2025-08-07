import Foundation

// MARK: - Shared Data Models

struct RoomCounts: Codable {
    let wellbeingCount: Int
    let diverseLearnersCount: Int
    let lunchCount: Int
    let timestamp: Date
}

struct ActivityLog: Codable {
    let room: String
    let action: String
    let studentName: String
    let timestamp: Date
}
