import SwiftUI

struct HeadCountView: View {
    @ObservedObject var studentStore: StudentStore
    @State private var wellbeingStudents: [Student] = []
    @State private var diverseLearnersStudents: [Student] = []
    @State private var lunchCount: Int = 0
    @State private var safetyWarnings: [String] = []
    @State private var lastAuditTime: Date = Date()
    @State private var showSafetyAlert: Bool = false
    
    let leavingOutcomes = [
        "Feeling Better",
        "Return to Class",
        "Going to Lunch",
        "Going to Recess",
        "Going to Library",
        "Going to Office",
        "Going to Nurse",
        "Going to Counselor",
        "Medical Appointment",
        "Parent Contact",
        "Going Home",
        "Other Out"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // Safety Warning Display
            if !safetyWarnings.isEmpty {
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Safety Warnings")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                    ForEach(safetyWarnings, id: \.self) { warning in
                        Text(warning)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
            
            VStack(spacing: 20) {
                Text("Head Count")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                // Room-specific head counts
                VStack(spacing: 15) {
                    // Wellbeing Room
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.green)
                            Text("Wellbeing Room")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Text("\(wellbeingStudents.count)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.green)
                        
                        Text("Students Currently in Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(15)
                    
                    // Diverse Learners Room
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.blue)
                            Text("Diverse Learners Room")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        Text("\(diverseLearnersStudents.count)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Students Currently in Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                    
                    // Lunch Room
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.orange)
                            Text("Lunch Room")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        
                        Text("\(lunchCount)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Students Currently in Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(15)
                }
            }
            
            // Show detailed student lists if any students are signed in
            if !wellbeingStudents.isEmpty || !diverseLearnersStudents.isEmpty || lunchCount > 0 {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Current Students:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            // Wellbeing Room Students
                            if !wellbeingStudents.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Wellbeing Room:")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    
                                    ForEach(wellbeingStudents) { student in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(student.fullName)
                                                    .font(.headline)
                                                Text("Year \(student.year) - \(student.teacher)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            
                            // Diverse Learners Room Students
                            if !diverseLearnersStudents.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Diverse Learners Room:")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    ForEach(diverseLearnersStudents) { student in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(student.fullName)
                                                    .font(.headline)
                                                Text("Year \(student.year) - \(student.teacher)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            
                            // Lunch Room Count
                            if lunchCount > 0 {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Lunch Room:")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Lunch Students")
                                                .font(.headline)
                                            Text("\(lunchCount) students currently in lunch room")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Students Currently in Any Room")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
                Spacer()
            }
        }
        .padding()
        .onAppear(perform: loadSignedInStudents)
        .refreshable {
            loadSignedInStudents()
        }
        .onReceive(NotificationCenter.default.publisher(for: .logDataCleared)) { _ in
            loadSignedInStudents()
        }
    }
    
    func loadSignedInStudents() {
        // Clear previous warnings
        safetyWarnings.removeAll()
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { 
            let error = "SAFETY ERROR: Cannot access documents directory"
            safetyWarnings.append(error)
            return 
        }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        guard let data = try? String(contentsOf: logURL, encoding: .utf8) else { 
            let error = "SAFETY ERROR: Cannot read log file - assuming no students signed in"
            safetyWarnings.append(error)
            wellbeingStudents = []
            diverseLearnersStudents = []
            lunchCount = 0
            return 
        }
        
        let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard rows.count > 1 else { 
            let info = "SAFETY INFO: No log entries found - no students signed in"
            safetyWarnings.append(info)
            wellbeingStudents = []
            diverseLearnersStudents = []
            lunchCount = 0
            return 
        }
        
        // Use ReasonStore for customizable reasons
        let reasonStore = ReasonStore()
        let signInReasons = reasonStore.signInReasons
        let signOutReasons = reasonStore.signOutReasons
        
        // Track student entries by room (excluding lunch room which uses separate tally)
        var wellbeingEntries: [String: [(action: String, timestamp: Date, reason: String)]] = [:]
        var diverseLearnersEntries: [String: [(action: String, timestamp: Date, reason: String)]] = [:]
        
        // Parse all entries with timestamps and room information
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            
            // Handle different CSV formats
            let name: String
            let reason: String
            let room: String
            let dateString: String
            
            if columns.count >= 7 {
                // New format with room: Name,Year,Teacher,Reason,Room,DateTime,Type
                name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                reason = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                room = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                dateString = columns[5].trimmingCharacters(in: .whitespacesAndNewlines)
            } else if columns.count >= 6 {
                // Check if this is the old format with room (Name,Year,Teacher,Reason,Room,Timestamp)
                let firstColumn = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let fourthColumn = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                let fifthColumn = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                
                // If 5th column looks like a room name (not a timestamp), it's the old format with room
                if fifthColumn.contains("Room") || fifthColumn.contains("Wellbeing") || fifthColumn.contains("Diverse") || fifthColumn.contains("Lunch") {
                    name = firstColumn
                    reason = fourthColumn
                    room = fifthColumn
                    dateString = columns[5].trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    // This is the current format: Name,Year,Teacher,Reason,DateTime,Type
                    name = firstColumn
                    reason = fourthColumn
                    room = "Unknown" // Use unknown for old format
                    dateString = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                }
            } else if columns.count >= 5 {
                // Old format without room - assume it's for the current room
                name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                reason = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                room = "Unknown" // Use unknown for old format
                dateString = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                continue
            }
            
            // Parse timestamp safely
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let timestamp = formatter.date(from: dateString) else { continue }
            
            // Determine action type
            var action = "UNKNOWN"
            if signInReasons.contains(reason) {
                action = "SIGN_IN"
            } else if signOutReasons.contains(reason) {
                action = "SIGN_OUT"
            } else {
                action = "SIGN_IN" // Default to sign-in for safety
            }
            
            // Store entry with timestamp and room
            if room == "Wellbeing Room" {
                if wellbeingEntries[name] == nil {
                    wellbeingEntries[name] = []
                }
                wellbeingEntries[name]?.append((action: action, timestamp: timestamp, reason: reason))
            } else if room == "Diverse Learners Room" {
                if diverseLearnersEntries[name] == nil {
                    diverseLearnersEntries[name] = []
                }
                diverseLearnersEntries[name]?.append((action: action, timestamp: timestamp, reason: reason))
            } else if room == "Lunch Room" {
                // Skip CSV parsing for lunch room - it uses separate tally system
                // Lunch room entries are logged but not counted here
                print("DEBUG: Skipping lunch room CSV entry for \(name)")
                continue
            }
        }
        
        // Determine current status for each room
        var currentlySignedInWellbeing: [String] = []
        var currentlySignedInDiverseLearners: [String] = []
        var currentlySignedInLunch: [String] = []
        
        // Wellbeing Room
        for (studentName, entries) in wellbeingEntries {
            guard !entries.isEmpty else { continue }
            
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            guard let lastEntry = sortedEntries.last else { continue }
            
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInWellbeing.append(studentName)
            }
        }
        
        // Diverse Learners Room
        for (studentName, entries) in diverseLearnersEntries {
            guard !entries.isEmpty else { continue }
            
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            guard let lastEntry = sortedEntries.last else { continue }
            
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInDiverseLearners.append(studentName)
            }
        }
        
        // Lunch Room - Skip CSV parsing, use separate tally system only
        // Lunch room count comes from lunch_count.txt file, not CSV entries
        
        // Convert to Student objects
        var wellbeingStudentsList: [Student] = []
        var diverseLearnersStudentsList: [Student] = []
        
        for student in studentStore.students {
            if currentlySignedInWellbeing.contains(student.fullName) {
                wellbeingStudentsList.append(student)
            }
            if currentlySignedInDiverseLearners.contains(student.fullName) {
                diverseLearnersStudentsList.append(student)
            }
        }
        
        wellbeingStudents = wellbeingStudentsList
        diverseLearnersStudents = diverseLearnersStudentsList
        
        // For lunch room, use ONLY the separate lunch count file - don't count CSV entries
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let lunchCountURL = documentsURL.appendingPathComponent("lunch_count.txt")
            print("DEBUG: HeadCountView - Reading lunch count from: \(lunchCountURL.path)")
            if let countString = try? String(contentsOf: lunchCountURL, encoding: .utf8), let count = Int(countString) {
                let oldLunchCount = lunchCount
                lunchCount = count
                print("DEBUG: HeadCountView - Lunch count updated: \(oldLunchCount) -> \(lunchCount)")
            } else {
                let oldLunchCount = lunchCount
                lunchCount = 0
                print("DEBUG: HeadCountView - No lunch count file found, resetting: \(oldLunchCount) -> \(lunchCount)")
            }
        } else {
            let oldLunchCount = lunchCount
            lunchCount = 0
            print("DEBUG: HeadCountView - Cannot access documents directory, resetting: \(oldLunchCount) -> \(lunchCount)")
        }
        
        print("DEBUG: Final lunch count set to: \(lunchCount)")
        
        // FINAL SAFETY AUDIT
        let auditMessage = "SAFETY AUDIT COMPLETE: Wellbeing(\(wellbeingStudents.count)), Diverse Learners(\(diverseLearnersStudents.count)), Lunch(\(lunchCount))"
        safetyWarnings.append(auditMessage)
        
        // Update last audit time
        lastAuditTime = Date()
    }
}
