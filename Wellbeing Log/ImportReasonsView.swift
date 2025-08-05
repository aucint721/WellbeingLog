import SwiftUI
import UniformTypeIdentifiers

struct ImportReasonsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingFilePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Import Reasons")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Select a CSV file to import reasons. Format: Reason In,Reason Out")
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
                    importReasonsFromFile(fileURL)
                }
            case .failure(let error):
                alertMessage = "Error selecting file: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
    
    private func importReasonsFromFile(_ fileURL: URL) {
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
            importReasonsFromCSV(csvData)
            alertMessage = "Reasons imported successfully!"
            showingAlert = true
        } catch {
            alertMessage = "Error reading file: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func importReasonsFromCSV(_ csvData: String) {
        let rows = csvData.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        guard rows.count > 1 else { return }
        
        var signInReasons: [String] = []
        var signOutReasons: [String] = []
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2 {
                let signInReason = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let signOutReason = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !signInReason.isEmpty {
                    signInReasons.append(signInReason)
                }
                if !signOutReason.isEmpty {
                    signOutReasons.append(signOutReason)
                }
            }
        }
        
        // Save the imported reasons
        let reasonStore = ReasonStore()
        reasonStore.signInReasons = signInReasons
        reasonStore.signOutReasons = signOutReasons
        reasonStore.saveReasonsToCSV()
    }
} 