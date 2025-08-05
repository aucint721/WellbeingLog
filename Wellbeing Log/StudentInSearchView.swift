import SwiftUI

struct StudentInSearchView: View {
    @ObservedObject var studentStore: StudentStore
    let roomType: RoomType
    @State private var searchText = ""
    @State private var signedInStudents: [Student] = []
    
    var filteredStudents: [Student] {
        // Show students who are available for sign-in (from signedInStudents)
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
    
    // Helper function for student image
    func studentImageView(for student: Student) -> some View {
        if let displayImage = student.displayImage {
            return AnyView(
                displayImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
            )
        } else {
            return AnyView(
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            )
        }
    }
    
    var body: some View {
        Group {
            if studentStore.isLoading {
                VStack(spacing: 20) {
                    ProgressView("Loading students...")
                        .font(.title2)
                    
                    Text("Please wait while we load your student data")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else if studentStore.hasError {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Error Loading Students")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Text(studentStore.errorMessage)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        studentStore.loadStudents()
                    }) {
                        Text("Try Again")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
                Spacer()
            } else if studentStore.students.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Students Loaded")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("Please import student data from the Settings menu.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // This will be handled by the navigation
                    }) {
                        Text("Go to Settings")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
                Spacer()
            } else if filteredStudents.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("All Students Already Signed In")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("All students are currently signed in. No students available for sign-in.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                VStack(spacing: 0) {
                    // Search bar with improved styling
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search students...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Results count
                    if !searchText.isEmpty {
                        HStack {
                            Text("\(filteredStudents.count) student\(filteredStudents.count == 1 ? "" : "s") found")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    List(filteredStudents) { student in
                        NavigationLink(destination: StudentDetailView(student: student, roomType: roomType)) {
                            HStack(spacing: 12) {
                                // Student Image
                                studentImageView(for: student)
                                
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
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationTitle("Student In")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadSignedInStudents()
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
            print("DEBUG: CSV file does not exist - setting all students as available")
            signedInStudents = studentStore.students
            print("DEBUG: Room: \(roomType.rawValue)")
            print("DEBUG: All students available: \(signedInStudents.map { $0.fullName })")
            return
        }
        
        guard let data = try? String(contentsOf: logURL, encoding: .utf8) else { 
            print("DEBUG: Could not read CSV file")
            return 
        }
        
        print("DEBUG: CSV file contents: \(data)")
        
        let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard rows.count > 1 else { 
            // If no CSV data exists, all students are available for sign-in
            signedInStudents = studentStore.students
            print("DEBUG: No CSV data found - all students available for sign-in")
            print("DEBUG: Room: \(roomType.rawValue)")
            print("DEBUG: All students available: \(signedInStudents.map { $0.fullName })")
            return 
        }
        
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
        
        // Simple approach: Find all students who have a SIGN_IN action as their most recent action
        var currentlySignedInStudents: [String] = []
        
        for (studentName, entries) in studentEntries {
            guard !entries.isEmpty else { continue }
            
            print("DEBUG: Processing student \(studentName) with \(entries.count) entries")
            
            // Sort all entries by timestamp to get chronological order
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            
            // Get the most recent action for this student (across all rooms)
            guard let lastEntry = sortedEntries.last else { continue }
            
            print("DEBUG: Student \(studentName) last action: \(lastEntry.action) in \(lastEntry.room) at \(lastEntry.timestamp)")
            
            // If the most recent action is SIGN_IN, the student is currently signed in
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInStudents.append(studentName)
                print("DEBUG: Student \(studentName) is currently signed in")
            } else {
                print("DEBUG: Student \(studentName) is NOT currently signed in")
            }
        }
        
        // Convert to Student objects - only students NOT currently signed in (so they can be signed in)
        signedInStudents = studentStore.students.filter { student in
            !currentlySignedInStudents.contains(student.fullName)
        }
        
        // Debug: Print what we found
        print("DEBUG: Room: \(roomType.rawValue)")
        print("DEBUG: Currently signed in students: \(currentlySignedInStudents)")
        print("DEBUG: Found \(signedInStudents.count) students for Student In")
        print("DEBUG: All students in store: \(studentStore.students.map { $0.fullName })")
        print("DEBUG: Students NOT signed in: \(signedInStudents.map { $0.fullName })")
        print("DEBUG: Filtered students for display: \(filteredStudents.map { $0.fullName })")
    }
}
