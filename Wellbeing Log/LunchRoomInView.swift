import SwiftUI

struct LunchRoomInView: View {
    @ObservedObject var studentStore: StudentStore
    @StateObject private var syncManager = RoomSyncManager()
    @State private var lunchCount = 0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(spacing: isIPad ? 50 : 30) {
            Text("Lunch Room - Students In")
                .font(.system(size: isIPad ? 48 : 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, isIPad ? 50 : 30)
                .padding(.bottom, isIPad ? 20 : 10)
                .multilineTextAlignment(.center)
            
            VStack(spacing: isIPad ? 40 : 20) {
                // Current Count Display
                VStack(spacing: isIPad ? 20 : 15) {
                    Text("Current Count")
                        .font(.system(size: isIPad ? 32 : 24, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text("\(syncManager.isConnected ? syncManager.lunchCount : lunchCount)")
                        .font(.system(size: isIPad ? 120 : 80, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .padding(.horizontal, isIPad ? 60 : 40)
                        .padding(.vertical, isIPad ? 30 : 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.orange, lineWidth: 3)
                                )
                        )
                }
                
                // Add Student Button
                Button(action: {
                    addStudentToLunch()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: isIPad ? 32 : 24))
                            .foregroundColor(.white)
                        
                        Text("Add Student")
                            .font(isIPad ? .largeTitle : .title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 100 : 60)
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, isIPad ? 40 : 20)
                
                // Reset Button
                Button(action: {
                    resetLunchCount()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: isIPad ? 32 : 24))
                            .foregroundColor(.white)
                        
                        Text("Reset Count")
                            .font(isIPad ? .largeTitle : .title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 100 : 60)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, isIPad ? 40 : 20)
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadLunchCount()
        }
    }
    
    func addStudentToLunch() {
        print("DEBUG: Before increment - lunchCount: \(lunchCount)")
        lunchCount += 1
        print("DEBUG: After increment - lunchCount: \(lunchCount)")
        logLunchEntry("Lunch Student \(lunchCount)", action: "IN")
        saveLunchCount()
        
        // Update sync manager
        syncManager.updateLunchCount(lunchCount)
        syncManager.logActivity(room: "Lunch Room", action: "IN", studentName: "Lunch Student \(lunchCount)")
    }
    
    func resetLunchCount() {
        lunchCount = 0
        saveLunchCount()
        
        // Update sync manager
        syncManager.updateLunchCount(lunchCount)
        syncManager.logActivity(room: "Lunch Room", action: "RESET", studentName: "All Students")
    }
    
    func loadLunchCount() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        
        let countURL = documentsURL.appendingPathComponent("lunch_count.txt")
        print("DEBUG: Loading lunch count from \(countURL.path)")
        if let data = try? String(contentsOf: countURL, encoding: .utf8) {
            let oldCount = lunchCount
            lunchCount = Int(data) ?? 0
            print("DEBUG: Loaded lunch count: \(oldCount) -> \(lunchCount)")
        } else {
            print("DEBUG: No lunch count file found, keeping current value: \(lunchCount)")
        }
    }
    
    func saveLunchCount() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        
        // Save to local file
        let countURL = documentsURL.appendingPathComponent("lunch_count.txt")
        print("DEBUG: Saving lunch count \(lunchCount) to \(countURL.path)")
        try? String(lunchCount).write(to: countURL, atomically: true, encoding: .utf8)
        

        
        // Notify other views that lunch count has changed
        NotificationCenter.default.post(name: .logDataCleared, object: nil)
    }
    
    func logLunchEntry(_ studentName: String, action: String) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        
        // Create header if file doesn't exist
        if !fileManager.fileExists(atPath: logURL.path) {
            let header = "Name,Year,Teacher,Reason,Room,Timestamp\n"
            try? header.write(to: logURL, atomically: true, encoding: .utf8)
        }
        
        // Create log entry
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        let reason = action == "IN" ? "Lunch Entry" : "Lunch Exit"
        let logEntry = "\(studentName),Lunch Year,Lunch Teacher,\(reason),Lunch Room,\(timestamp)\n"
        
        // Append to log file
        if let fileHandle = try? FileHandle(forWritingTo: logURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(logEntry.data(using: .utf8)!)
            fileHandle.closeFile()
        }
    }
} 