import Foundation
import CloudKit
import SwiftUI

class RoomSyncManager: ObservableObject {
    @Published var wellbeingCount: Int = 0
    @Published var diverseLearnersCount: Int = 0
    @Published var lunchCount: Int = 0
    @Published var lastSyncTime: Date = Date()
    @Published var isConnected: Bool = false
    @Published var syncError: String?
    
    private let container = CKContainer.default()
    private let database = CKContainer.default().publicCloudDatabase
    private var timer: Timer?
    
    // Record types for CloudKit
    private let roomCountsRecordType = "RoomCounts"
    private let roomActivityRecordType = "RoomActivity"
    
    init() {
        setupSync()
        startPeriodicSync()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Setup and Configuration
    
    private func setupSync() {
        // Check CloudKit availability
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                if status == .available {
                    self?.isConnected = true
                    self?.loadCurrentCounts()
                } else {
                    self?.isConnected = false
                    self?.syncError = "CloudKit not available: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }
    }
    
    private func startPeriodicSync() {
        // Sync every 30 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.syncCounts()
        }
    }
    
    // MARK: - Public Methods
    
    func updateWellbeingCount(_ count: Int) {
        wellbeingCount = count
        syncCounts()
    }
    
    func updateDiverseLearnersCount(_ count: Int) {
        diverseLearnersCount = count
        syncCounts()
    }
    
    func updateLunchCount(_ count: Int) {
        lunchCount = count
        syncCounts()
    }
    
    func forceSync() {
        syncCounts()
    }
    
    // MARK: - CloudKit Operations
    
    private func syncCounts() {
        guard isConnected else { return }
        
        let record = CKRecord(recordType: roomCountsRecordType)
        record["wellbeingCount"] = wellbeingCount
        record["diverseLearnersCount"] = diverseLearnersCount
        record["lunchCount"] = lunchCount
        record["timestamp"] = Date()
        record["deviceID"] = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        
        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.syncError = "Sync failed: \(error.localizedDescription)"
                } else {
                    self?.lastSyncTime = Date()
                    self?.syncError = nil
                }
            }
        }
    }
    
    func loadCurrentCounts() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: roomCountsRecordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        
        operation.recordMatchedBlock = { [weak self] (recordID, result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let record):
                    self?.wellbeingCount = record["wellbeingCount"] as? Int ?? 0
                    self?.diverseLearnersCount = record["diverseLearnersCount"] as? Int ?? 0
                    self?.lunchCount = record["lunchCount"] as? Int ?? 0
                    self?.lastSyncTime = record["timestamp"] as? Date ?? Date()
                case .failure(let error):
                    self?.syncError = "Load failed: \(error.localizedDescription)"
                }
            }
        }
        
        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.syncError = nil
                case .failure(let error):
                    self?.syncError = "Load failed: \(error.localizedDescription)"
                }
            }
        }
        
        database.add(operation)
    }
    
    // MARK: - Activity Logging
    
    func logActivity(room: String, action: String, studentName: String) {
        guard isConnected else { return }
        
        let record = CKRecord(recordType: roomActivityRecordType)
        record["room"] = room
        record["action"] = action
        record["studentName"] = studentName
        record["timestamp"] = Date()
        record["deviceID"] = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        
        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.syncError = "Activity log failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Real-time Updates
    
    func startRealTimeUpdates() {
        loadCurrentCounts()
    }
}

// RoomType is defined in RoomType.swift - no duplicate needed here
