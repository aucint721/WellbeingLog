import Foundation
import CloudKit

// CloudKit Configuration for Wellbeing Log App
// This file contains configuration settings for CloudKit integration

struct CloudKitConfig {
    // CloudKit Container Identifier
    static let containerIdentifier = "iCloud.com.HennieAucamp.wellbeinglog"
    
    // Record Types
    struct RecordTypes {
        static let roomCounts = "RoomCounts"
        static let roomActivity = "RoomActivity"
        static let studentLog = "StudentLog"
    }
    
    // Field Names
    struct Fields {
        // Room Counts
        static let wellbeingCount = "wellbeingCount"
        static let diverseLearnersCount = "diverseLearnersCount"
        static let lunchCount = "lunchCount"
        static let timestamp = "timestamp"
        static let deviceID = "deviceID"
        
        // Room Activity
        static let room = "room"
        static let action = "action"
        static let studentName = "studentName"
        
        // Student Log
        static let studentID = "studentID"
        static let roomTypeField = "roomType"
        static let signInTime = "signInTime"
        static let signOutTime = "signOutTime"
        static let reason = "reason"
    }
    
    // CloudKit Database
    static var database: CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }
    
    // CloudKit Container
    static var container: CKContainer {
        return CKContainer.default()
    }
    
    // Check CloudKit availability
    static func checkCloudKitAvailability(completion: @escaping (Bool, Error?) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                completion(status == .available, error)
            }
        }
    }
    
    // Setup CloudKit schema (call this once during app setup)
    static func setupCloudKitSchema() {
        // This would typically be done through the CloudKit Dashboard
        // For now, we'll just verify the container is accessible
        checkCloudKitAvailability { isAvailable, error in
            if isAvailable {
                print("CloudKit is available and ready for use")
            } else {
                print("CloudKit is not available: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

// MARK: - CloudKit Error Handling

enum CloudKitError: Error, LocalizedError {
    case accountNotAvailable
    case networkError
    case permissionDenied
    case quotaExceeded
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accountNotAvailable:
            return "iCloud account not available. Please sign in to iCloud in Settings."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .permissionDenied:
            return "Permission denied. Please check your iCloud settings."
        case .quotaExceeded:
            return "iCloud storage quota exceeded. Please free up some space."
        case .unknown:
            return "An unknown error occurred with CloudKit."
        }
    }
}

// MARK: - CloudKit Utilities

extension CloudKitConfig {
    static func handleCloudKitError(_ error: Error) -> CloudKitError {
        if let ckError = error as? CKError {
            switch ckError.code {
            case .notAuthenticated:
                return .accountNotAvailable
            case .networkUnavailable, .networkFailure:
                return .networkError
            case .permissionFailure:
                return .permissionDenied
            case .quotaExceeded:
                return .quotaExceeded
            default:
                return .unknown
            }
        }
        return .unknown
    }
}
