import SwiftUI

struct LunchStudentOutDetailView: View {
    let studentName: String
    let roomType: RoomType
    @State private var selectedOutcome = "Feeling Better"
    @State private var customOutcome = ""
    @State private var showCustomOutcome = false
    @State private var showConfirmation = false
    @State private var isIPad = false
    
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
            // Student Header
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                
                Text(studentName)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Lunch Student")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text("Lunch Room")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(20)
            
            // Outcome Selection
            VStack(alignment: .leading, spacing: 20) {
                Text("Select Outcome")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isIPad ? 3 : 2), spacing: 15) {
                    ForEach(leavingOutcomes, id: \.self) { outcome in
                        Button(action: {
                            selectedOutcome = outcome
                            if outcome == "Other Out" {
                                showCustomOutcome = true
                            }
                        }) {
                            HStack {
                                Image(systemName: selectedOutcome == outcome ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedOutcome == outcome ? .blue : .gray)
                                    .font(.title2)
                                
                                Text(outcome)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedOutcome == outcome ? .blue : .primary)
                                
                                Spacer()
                            }
                            .padding()
                            .background(selectedOutcome == outcome ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedOutcome == outcome ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                if showCustomOutcome {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Custom Outcome")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        TextField("Enter custom outcome...", text: $customOutcome)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title3)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
            
            // Sign Out Button
            Button(action: {
                showConfirmation = true
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: isIPad ? 32 : 24))
                        .foregroundColor(.white)
                    
                    Text("Sign Out Student")
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
        .padding()
        .navigationTitle("Sign Out Lunch Student")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Check if device is iPad
            isIPad = UIDevice.current.userInterfaceIdiom == .pad
        }
        .alert("Confirm Sign Out", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                confirmSignOut()
            }
        } message: {
            Text("Are you sure you want to sign out \(studentName)?")
        }
    }
    
    func confirmSignOut() {
        let finalOutcome = selectedOutcome == "Other Out" && !customOutcome.isEmpty ? customOutcome : selectedOutcome
        
        // Create log entry
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        let logEntry = "\(studentName),Lunch Year,Lunch Teacher,\(finalOutcome),Lunch Room,\(timestamp),SIGN_OUT\n"
        
        // Write to log file
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else {
            print("ERROR: Could not access documents directory")
            return
        }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        
        // Create header if file doesn't exist
        if !fileManager.fileExists(atPath: logURL.path) {
            let header = "Name,Year,Teacher,Reason,Room,DateTime,Type\n"
            try? header.write(to: logURL, atomically: true, encoding: .utf8)
        }
        
        // Append to log file
        if let fileHandle = try? FileHandle(forWritingTo: logURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(logEntry.data(using: .utf8)!)
            fileHandle.closeFile()
        }
        
        // Navigate back to the student list
        // This will be handled by the navigation stack
    }
} 