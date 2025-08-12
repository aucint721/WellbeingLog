import SwiftUI

struct SettingsView: View {
    @ObservedObject var studentStore: StudentStore
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingConfirmation = false
    @State private var confirmationAction: String = ""
    @State private var showingImportSheet = false
    @State private var showingReasonsImportSheet = false
    @State private var showingPurchaseSheet = false

    
    var body: some View {
        NavigationView {
            List {
                // Subscription Status Header
                Section {
                    VStack(spacing: 16) {
                        // Premium Badge for Premium Users
                        if subscriptionManager.isPurchased {
                            PremiumBadgeView(size: 120)
                                .padding(.vertical, 8)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: subscriptionManager.isPurchased ? "crown.fill" : 
                                              subscriptionManager.isInTrial ? "clock.badge" : "exclamationmark.triangle.fill")
                                        .foregroundColor(subscriptionManager.isPurchased ? .yellow : 
                                                       subscriptionManager.isInTrial ? .blue : .orange)
                                        .font(.title)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(subscriptionManager.isPurchased ? "Premium Active" : 
                                             subscriptionManager.isInTrial ? "Trial Period" : "Trial Expired")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        
                                        Text(subscriptionManager.trialStatusDescription)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if subscriptionManager.isInTrial {
                                            Text(subscriptionManager.trialExpirationText)
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            
                            if subscriptionManager.isInTrial {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("\(subscriptionManager.trialDaysRemaining) days remaining")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        Spacer()
                                        if !subscriptionManager.isPurchased {
                                            Button("Upgrade Now") {
                                                showingPurchaseSheet = true
                                            }
                                            .buttonStyle(.borderedProminent)
                                            .controlSize(.small)
                                        }
                                    }
                                    
                                    // Trial Progress Bar
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("Trial Progress")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Text("\(Int(subscriptionManager.trialProgressPercentage * 100))%")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        ProgressView(value: subscriptionManager.trialProgressPercentage)
                                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                    }
                                    
                                    // Premium Preview for Trial Users
                                    VStack(alignment: .center, spacing: 8) {
                                        Text("Upgrade to Premium")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.top, 8)
                                        
                                        PremiumBadgeView(size: 80)
                                            .opacity(0.8)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Student Management").font(.title2).fontWeight(.bold)) {
                    Button(action: {
                        exportStudents()
                    }) {
                        HStack {
                            Image(systemName: "person.2.doc")
                                .foregroundColor(.blue)
                            Text("Export Students")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        importStudents()
                    }) {
                        HStack {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.green)
                            Text("Import Students")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        downloadSampleStudents()
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.doc")
                                .foregroundColor(.purple)
                            Text("Download Sample Students")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Reason Management").font(.title2).fontWeight(.bold)) {
                    Button(action: {
                        downloadSampleReasons()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard")
                                .foregroundColor(.indigo)
                            Text("Download Sample Reasons")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        importReasons()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .foregroundColor(.green)
                            Text("Import Reasons")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        exportReasons()
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text("Export Reasons")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Data Management").font(.title2).fontWeight(.bold)) {
                    Button(action: {
                        exportStatistics()
                    }) {
                        HStack {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .foregroundColor(.green)
                            Text("Export Statistics")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        exportLogData()
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.orange)
                            Text("Export Log Data")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Data Clearing").font(.title2).fontWeight(.bold)) {
                    Button(action: {
                        confirmationAction = "clearLog"
                        showingConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear Log Data")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        confirmationAction = "clearStudents"
                        showingConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "person.2.slash")
                                .foregroundColor(.red)
                            Text("Clear All Students")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("App Information").font(.title2).fontWeight(.bold)) {
                    HStack {
                        Text("Version")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("1.0.0")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Students Loaded")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(studentStore.students.count)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Subscription & Trial").font(.title2).fontWeight(.bold)) {
                    // Trial Status
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: subscriptionManager.isPurchased ? "checkmark.circle.fill" : 
                                      subscriptionManager.isInTrial ? "clock.fill" : "exclamationmark.circle.fill")
                                .foregroundColor(subscriptionManager.isPurchased ? .green : 
                                               subscriptionManager.isInTrial ? .blue : .orange)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subscriptionManager.purchaseStatusText)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(subscriptionManager.trialStatusDescription)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        // Trial Progress Bar (only show if in trial)
                        if subscriptionManager.isInTrial {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Trial Progress")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(subscriptionManager.trialDaysRemaining) days left")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                ProgressView(value: subscriptionManager.trialProgressPercentage)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                            }
                        }
                        
                        // Trial Dates
                        if let _ = subscriptionManager.trialStartDate {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Trial Started:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(subscriptionManager.formattedTrialStartDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("Trial Ends:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(subscriptionManager.formattedTrialEndDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Purchase Button (only show if not purchased)
                    if !subscriptionManager.isPurchased {
                        Button(action: {
                            showingPurchaseSheet = true
                        }) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                    .foregroundColor(.white)
                                Text("Upgrade to Premium")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(subscriptionManager.productPrice)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.vertical, 8)
                        
                        // Restore Purchases Button
                        Button(action: {
                            Task {
                                await subscriptionManager.restorePurchases()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.blue)
                                Text("Restore Purchases")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .confirmationDialog("Confirm Action", isPresented: $showingConfirmation) {
                Button("Clear Log Data", role: .destructive) {
                    if confirmationAction == "clearLog" {
                        clearLogData()
                    }
                }
                Button("Clear All Students", role: .destructive) {
                    if confirmationAction == "clearStudents" {
                        clearAllStudents()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
            .sheet(isPresented: $showingImportSheet) {
                ImportStudentsView(studentStore: studentStore)
            }
            .sheet(isPresented: $showingReasonsImportSheet) {
                ImportReasonsView()
            }
            .sheet(isPresented: $showingPurchaseSheet) {
                PurchaseView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func exportStatistics() {
        let statistics = generateStatistics()
        let csvData = statistics.toCSV()
        shareCSVFile(csvData, filename: "Statistics.csv")
    }
    
    private func exportLogData() {
        let csvData = exportLogDataToCSV()
        shareCSVFile(csvData, filename: "Log_Data.csv")
    }
    
    private func exportReasons() {
        let csvData = generateReasonsCSV()
        shareCSVFile(csvData, filename: "Reasons_List.csv")
    }
    
    private func generateReasonsCSV() -> String {
        var csv = "Reason In,Reason Out\n"
        
        // Get current reasons from ReasonStore
        let reasonStore = ReasonStore()
        let signInReasons = reasonStore.signInReasons
        let signOutReasons = reasonStore.signOutReasons
        
        // Find the maximum length to pad the CSV properly
        let maxLength = max(signInReasons.count, signOutReasons.count)
        
        for i in 0..<maxLength {
            let signInReason = i < signInReasons.count ? signInReasons[i] : ""
            let signOutReason = i < signOutReasons.count ? signOutReasons[i] : ""
            csv += "\(signInReason),\(signOutReason)\n"
        }
        
        return csv
    }
    
    private func clearLogData() {
        // Clear the log file
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logURL = documentsPath.appendingPathComponent("StudentEntryLog.csv")
            try? FileManager.default.removeItem(at: logURL)
            
            // Also clear the lunch count file
            let lunchCountURL = documentsPath.appendingPathComponent("lunch_count.txt")
            try? FileManager.default.removeItem(at: lunchCountURL)
        }
        
        NotificationCenter.default.post(name: .logDataCleared, object: nil)
        alertTitle = "Success"
        alertMessage = "Log data cleared successfully"
        showingAlert = true
    }
    
    private func clearAllStudents() {
        studentStore.students.removeAll()
        studentStore.saveStudents()
        alertTitle = "Success"
        alertMessage = "All students cleared successfully"
        showingAlert = true
    }
    
    private func exportStudents() {
        let csvData = generateStudentsCSV()
        shareCSVFile(csvData, filename: "Student_List.csv")
    }
    
    private func importStudents() {
        showingImportSheet = true
    }
    
    private func importReasons() {
        showingReasonsImportSheet = true
    }
    
    private func generateStudentsCSV() -> String {
        var csv = "FirstName,LastName,Year,Teacher,Image\n"
        
        for student in studentStore.students {
            let imageData = student.imageData ?? ""
            csv += "\(student.firstName),\(student.lastName),\(student.year),\(student.teacher),\(imageData)\n"
        }
        
        return csv
    }
    
    private func shareCSVFile(_ csvData: String, filename: String) {
        // Create a temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileURL = tempDir.appendingPathComponent(filename)
        
        do {
            try csvData.write(to: tempFileURL, atomically: true, encoding: .utf8)
            
            // Create activity view controller
            let activityVC = UIActivityViewController(activityItems: [tempFileURL], applicationActivities: nil)
            
            // Configure for iPad
            if let popover = activityVC.popoverPresentationController {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    popover.sourceView = window.rootViewController?.view
                }
                popover.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            // Present the share sheet with delay to ensure any alerts are dismissed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootViewController = window.rootViewController {
                    
                    // Dismiss any existing presented view controllers
                    if let presentedVC = rootViewController.presentedViewController {
                        presentedVC.dismiss(animated: false) {
                            rootViewController.present(activityVC, animated: true)
                        }
                    } else {
                        rootViewController.present(activityVC, animated: true)
                    }
                }
            }
        } catch {
            print("Error creating temporary file: \(error)")
        }
    }
    

    
    private func downloadSampleStudents() {
        let sampleCSV = generateSampleStudentsCSV()
        shareCSVFile(sampleCSV, filename: "Sample_Students.csv")
    }
    
    private func generateSampleStudentsCSV() -> String {
        return """
FirstName,LastName,Year,Teacher,Image
John,Smith,9,Mr. Johnson,
Emma,Davis,12,Mr. Wilson,
Sarah,Wilson,10,Mrs. Davis,
Michael,Brown,11,Ms. Thompson,
James,Miller,9,Mrs. Anderson,
Olivia,Taylor,10,Mr. Garcia,
William,Anderson,11,Mrs. Rodriguez,
Sophia,Martinez,9,Mr. Lee,
Benjamin,Thompson,12,Mrs. White,
Ava,Robinson,10,Mr. Clark,
"""
    }
    
    private func downloadSampleReasons() {
        let sampleCSV = generateSampleReasonsCSV()
        shareCSVFile(sampleCSV, filename: "Sample_Reasons.csv")
    }
    
    private func generateSampleReasonsCSV() -> String {
        return """
Reason In,Reason Out
Anxiety/Stress,Feeling Better
Friendship Issues,Return to Class
Sensory Overload,Going to Lunch
Academic Stress,Going to Recess
Family Issues,Going to Library
Need Quiet Time,Going to Office
Medical Issue,Going to Nurse
Counseling Session,Going to Counselor
Other In,Medical Appointment
,Parent Contact
,Going Home
,Other Out
"""
    }
    
    private func generateStatistics() -> Statistics {
        let totalStudents = studentStore.students.count
        let totalEntries = getLogEntryCount()
        
        let calendar = Calendar.current
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start ?? today
        
        let todayEntries = getLogEntriesForDate(startOfToday)
        let thisWeekEntries = getLogEntriesForDate(startOfWeek)
        let thisMonthEntries = getLogEntriesForDate(startOfMonth)
        
        return Statistics(
            totalStudents: totalStudents,
            totalEntries: totalEntries,
            todayEntries: todayEntries,
            thisWeekEntries: thisWeekEntries,
            thisMonthEntries: thisMonthEntries
        )
    }
    
    private func getLogEntryCount() -> Int {
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logURL = documentsPath.appendingPathComponent("StudentEntryLog.csv")
            if let data = try? String(contentsOf: logURL, encoding: .utf8) {
                let lines = data.components(separatedBy: .newlines)
                return max(0, lines.count - 1) // Subtract header
            }
        }
        return 0
    }
    
    private func getLogEntriesForDate(_ startDate: Date) -> Int {
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logURL = documentsPath.appendingPathComponent("StudentEntryLog.csv")
            if let data = try? String(contentsOf: logURL, encoding: .utf8) {
                let lines = data.components(separatedBy: .newlines)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                return lines.dropFirst().filter { line in
                    let columns = line.components(separatedBy: ",")
                    if let dateString = columns.last?.trimmingCharacters(in: .whitespacesAndNewlines),
                       let date = formatter.date(from: dateString) {
                        return date >= startDate
                    }
                    return false
                }.count
            }
        }
        return 0
    }
    
    private func exportLogDataToCSV() -> String {
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logURL = documentsPath.appendingPathComponent("StudentEntryLog.csv")
            if let data = try? String(contentsOf: logURL, encoding: .utf8) {
                return data
            }
        }
        return "Name,Reason,Date,Time,Room,Type\n"
    }
}

struct Statistics {
    let totalStudents: Int
    let totalEntries: Int
    let todayEntries: Int
    let thisWeekEntries: Int
    let thisMonthEntries: Int
    
    func toCSV() -> String {
        let header = "Metric,Value\n"
        let rows = [
            "Total Students,\(totalStudents)",
            "Total Entries,\(totalEntries)",
            "Today's Entries,\(todayEntries)",
            "This Week's Entries,\(thisWeekEntries)",
            "This Month's Entries,\(thisMonthEntries)"
        ].joined(separator: "\n")
        
        return header + rows
    }
}

struct ImportStudentsView: View {
    @ObservedObject var studentStore: StudentStore
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingFilePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Import Students from CSV")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Select a CSV file to import students. Format: FirstName,LastName,Year,Teacher,Image")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Select CSV File") {
                    showingFilePicker = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Done") { dismiss() }
            )
        }
        .alert("Import Result", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.commaSeparatedText, .text, .plainText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                if let fileURL = files.first {
                    importStudentsFromFile(fileURL)
                }
            case .failure(let error):
                alertMessage = "Error selecting file: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
    
    private func importStudentsFromFile(_ fileURL: URL) {
        // Start accessing the security-scoped resource
        guard fileURL.startAccessingSecurityScopedResource() else {
            alertMessage = "Permission denied: Cannot access the selected file"
            showingAlert = true
            return
        }
        
        defer {
            // Stop accessing the security-scoped resource
            fileURL.stopAccessingSecurityScopedResource()
        }
        
        do {
            let csvData = try String(contentsOf: fileURL, encoding: .utf8)
            importStudentsFromCSV(csvData)
            alertMessage = "Students imported successfully!"
            showingAlert = true
        } catch {
            alertMessage = "Error reading file: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func importStudentsFromCSV(_ csvData: String) {
        let rows = csvData.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        guard rows.count > 1 else { return }
        
        var newStudents: [Student] = []
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 4 {
                let firstName = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let lastName = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let year = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)
                let teacher = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Handle optional image data (5th column)
                let imageData = columns.count >= 5 ? columns[4].trimmingCharacters(in: .whitespacesAndNewlines) : nil
                
                let student = Student(firstName: firstName, lastName: lastName, year: year, teacher: teacher, imageData: imageData)
                newStudents.append(student)
            }
        }
        
        if !newStudents.isEmpty {
            studentStore.students = newStudents
            studentStore.saveStudents()
        }
    }
}




