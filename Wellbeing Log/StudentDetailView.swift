import SwiftUI

struct StudentDetailView: View {
    let student: Student
    let roomType: RoomType
    @State private var selectedReason = "Anxiety/Stress"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var reasonStore: ReasonStore
    
    var signInReasons: [String] {
        return reasonStore.signInReasons
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Student Image
            VStack(spacing: 10) {
                if let displayImage = student.displayImage {
                    displayImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue.opacity(0.3), lineWidth: 3))
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .shadow(radius: 5)
                }
                
                Text(student.fullName)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Student Details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(student.fullName)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Year: \(student.year)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Teacher: \(student.teacher)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Reason for Visit")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                // Show current sign-in status
                let isCurrentlySignedIn = getStudentCurrentStatus()
                if isCurrentlySignedIn {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Already signed in")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Picker("Reason", selection: $selectedReason) {
                    ForEach(signInReasons, id: \.self) { reason in
                        Text(reason)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .tag(reason)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                )
            }
            
            Button(action: confirmSignIn) {
                Text("Confirm Sign In")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
        .alert("Sign In", isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    func getStudentCurrentStatus() -> Bool {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return false }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        guard let data = try? String(contentsOf: logURL, encoding: .utf8) else { return false }
        
        let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard rows.count > 1 else { return false }
        
        var lastAction: String? = nil
        
        let signInReasons = ["Anxiety/Stress", "Friendship Issues", "Sensory Overload", "Academic Stress", "Family Issues", "Need Quiet Time", "Medical Issue", "Counseling Session", "Other In"]
        let signOutReasons = ["Feeling Better", "Return to Class", "Going to Lunch", "Going to Recess", "Going to Library", "Going to Office", "Going to Nurse", "Going to Counselor", "Medical Appointment", "Parent Contact", "Going Home", "Other Out"]
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 5 else { continue }
            
            let name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let reason = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if name == student.fullName {
                if signInReasons.contains(reason) {
                    lastAction = "SIGN_IN"
                } else if signOutReasons.contains(reason) {
                    lastAction = "SIGN_OUT"
                }
            }
        }
        
        return lastAction == "SIGN_IN"
    }
    
    func confirmSignIn() {
        let finalReason = selectedReason
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        let logEntry = "\(student.fullName),\(student.year),\(student.teacher),\(finalReason),\(roomType.rawValue),\(timestamp),SIGN_IN\n"
        
        // Write to log file
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else {
            alertMessage = "Error accessing documents directory"
            showingAlert = true
            return
        }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        
        // Create header if file doesn't exist
        if !fileManager.fileExists(atPath: logURL.path) {
            let header = "Name,Year,Teacher,Reason,Room,DateTime,Type\n"
            try? header.write(to: logURL, atomically: true, encoding: .utf8)
        }
        
        // Append log entry
        if let fileHandle = try? FileHandle(forWritingTo: logURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(logEntry.data(using: .utf8)!)
            fileHandle.closeFile()
        }
        
        // Just dismiss the view without showing an alert
        dismiss()
    }
}
