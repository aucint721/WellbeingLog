import SwiftUI

struct StudentOutSearchView: View {
    @ObservedObject var studentStore: StudentStore
    let roomType: RoomType
    @State private var signedInStudents: [Student] = []
    @State private var lunchStudents: [String] = [] // For lunch room students
    @State private var searchText = ""
    
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
    
    var filteredSignedInStudents: [Student] {
        if searchText.isEmpty {
            return signedInStudents
        } else {
            return signedInStudents.filter { student in
                student.fullName.localizedCaseInsensitiveContains(searchText) ||
                student.year.localizedCaseInsensitiveContains(searchText) ||
                student.teacher.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredLunchStudents: [String] {
        if searchText.isEmpty {
            return lunchStudents
        } else {
            return lunchStudents.filter { studentName in
                studentName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        Group {
            if roomType == .lunch {
                // Special handling for Lunch Room
                if lunchStudents.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Students Currently in Lunch Room")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Text("Students will appear here after they sign in")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List(filteredLunchStudents, id: \.self) { studentName in
                        NavigationLink(destination: LunchStudentOutDetailView(studentName: studentName, roomType: roomType)) {
                            HStack(spacing: 12) {
                                // Student Image
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.orange)
                                
                                // Student Information
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(studentName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Text("Lunch Student")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("Lunch Room")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            } else {
                // Regular handling for other rooms
                if signedInStudents.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Students Currently Signed In")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Text("Students will appear here after they sign in")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List(filteredSignedInStudents) { student in
                        NavigationLink(destination: StudentOutDetailView(student: student, roomType: roomType)) {
                            HStack(spacing: 12) {
                                // Student Image
                                if let displayImage = student.displayImage {
                                    displayImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                
                                // Student Information
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(student.fullName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Text("Year \(student.year)")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(student.teacher)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Sign Out Student")
        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                        TextField("Search signed in students...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.darkGray), lineWidth: 2)
                    )
                }
        }
        .onAppear {
            loadSignedInStudents()
            // Clear search text when returning to the list
            searchText = ""
        }
        .onReceive(NotificationCenter.default.publisher(for: .logDataCleared)) { _ in
            loadSignedInStudents()
        }
    }
    
    func loadSignedInStudents() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { 
            print("DEBUG: Could not get documents directory")
            return 
        }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        print("DEBUG: Looking for CSV file at: \(logURL.path)")
        
        guard fileManager.fileExists(atPath: logURL.path) else {
            print("DEBUG: CSV file does not exist")
            return
        }
        
        guard let data = try? String(contentsOf: logURL, encoding: .utf8) else { 
            print("DEBUG: Could not read CSV file")
            return 
        }
        
        print("DEBUG: CSV file contents: \(data)")
        
        let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard rows.count > 1 else { return }
        
        // Define what constitutes sign-in vs sign-out reasons
        let signInReasons = [
            "Anxiety/Stress",
            "Friendship Issues", 
            "Sensory Overload",
            "Academic Stress",
            "Family Issues",
            "Need Quiet Time",
            "Medical Issue",
            "Counseling Session",
            "Other In"
        ]
        
        let signOutReasons = [
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
        
        // Track student entries by room
        var studentEntries: [String: [(action: String, timestamp: Date, reason: String, room: String)]] = [:]
        
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
                    room = roomType.rawValue // Use current room type for old format
                    dateString = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                }
            } else if columns.count >= 5 {
                // Old format without room - assume it's for the current room
                name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                reason = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                room = roomType.rawValue // Use current room type
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
            if studentEntries[name] == nil {
                studentEntries[name] = []
            }
            studentEntries[name]?.append((action: action, timestamp: timestamp, reason: reason, room: room))
        }
        
        // Determine current status based on most recent action in THIS ROOM
        var currentlySignedInToRoom: [String] = []
        
        print("DEBUG: Processing \(studentEntries.count) students with entries")
        
        for (studentName, entries) in studentEntries {
            guard !entries.isEmpty else { continue }
            
            print("DEBUG: Student \(studentName) has \(entries.count) total entries")
            
            // Filter entries for this specific room
            let roomEntries = entries.filter { $0.room == roomType.rawValue }
            guard !roomEntries.isEmpty else { 
                print("DEBUG: No entries for \(studentName) in room \(roomType.rawValue)")
                continue 
            }
            
            print("DEBUG: Student \(studentName) has \(roomEntries.count) entries in room \(roomType.rawValue)")
            
            // Sort by timestamp to get chronological order
            let sortedEntries = roomEntries.sorted { $0.timestamp < $1.timestamp }
            
            // Get the most recent action in this room
            guard let lastEntry = sortedEntries.last else { continue }
            
            print("DEBUG: Student \(studentName) last action in \(roomType.rawValue): \(lastEntry.action) at \(lastEntry.timestamp)")
            
            // Current status is based on last action in this room
            if lastEntry.action == "SIGN_IN" {
                print("DEBUG: Adding \(studentName) to currently signed in list for \(roomType.rawValue)")
                currentlySignedInToRoom.append(studentName)
            } else {
                print("DEBUG: \(studentName) is not currently signed in to \(roomType.rawValue) (last action: \(lastEntry.action))")
            }
        }
        
        if roomType == .lunch {
            // For lunch room, read from lunch_count.txt instead of CSV
            var lunchCountFromFile = 0
            if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let lunchCountURL = documentsURL.appendingPathComponent("lunch_count.txt")
                if let countString = try? String(contentsOf: lunchCountURL, encoding: .utf8), let count = Int(countString) {
                    lunchCountFromFile = count
                    print("DEBUG: Lunch count from file for Student Out: \(lunchCountFromFile)")
                } else {
                    print("DEBUG: No lunch count file found for Student Out")
                }
            }
            
            // Create lunch student names based on the count
            lunchStudents = []
            for i in 1...lunchCountFromFile {
                lunchStudents.append("Lunch Student \(i)")
            }
            signedInStudents = []
            print("DEBUG: Created \(lunchStudents.count) lunch students for Student Out")
        } else {
            // For other rooms, convert to Student objects
            signedInStudents = studentStore.students.filter { student in
                currentlySignedInToRoom.contains(student.fullName)
            }
            lunchStudents = []
        }
        
        // Debug: Print what we found
        print("DEBUG: Room: \(roomType.rawValue)")
        print("DEBUG: Currently signed in to room: \(currentlySignedInToRoom)")
        print("DEBUG: Found \(signedInStudents.count) students for Student Out")
        print("DEBUG: Found \(lunchStudents.count) lunch students for Student Out")
        print("DEBUG: All student entries: \(studentEntries.keys)")
        print("DEBUG: Lunch students for display: \(lunchStudents)")
    }
}
