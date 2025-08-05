import Foundation

class ReasonStore: ObservableObject {
    @Published var signInReasons: [String] = [] {
        didSet {
            // Auto-save whenever reasons change
            saveReasonsToCSV()
        }
    }
    @Published var signOutReasons: [String] = [] {
        didSet {
            // Auto-save whenever reasons change
            saveReasonsToCSV()
        }
    }
    
    init() {
        loadReasons()
    }
    
    func loadReasons() {
        // Load from CSV file if it exists, otherwise use defaults
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let reasonsURL = documentsURL.appendingPathComponent("reasons.csv")
            
            if let data = try? String(contentsOf: reasonsURL, encoding: .utf8) {
                parseReasonsFromCSV(data)
            } else {
                // Use default reasons if CSV doesn't exist
                setDefaultReasons()
            }
        } else {
            setDefaultReasons()
        }
    }
    
    private func parseReasonsFromCSV(_ csvData: String) {
        let rows = csvData.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        guard rows.count > 1 else {
            setDefaultReasons()
            return
        }
        
        var newSignInReasons: [String] = []
        var newSignOutReasons: [String] = []
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2 {
                let reason = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let type = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if type.lowercased() == "in" {
                    newSignInReasons.append(reason)
                } else if type.lowercased() == "out" {
                    newSignOutReasons.append(reason)
                }
            }
        }
        
        // Only update if we found valid reasons
        if !newSignInReasons.isEmpty {
            signInReasons = newSignInReasons
        }
        if !newSignOutReasons.isEmpty {
            signOutReasons = newSignOutReasons
        }
    }
    
    private func setDefaultReasons() {
        signInReasons = [
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
        
        signOutReasons = [
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
    }
    
    func saveReasonsToCSV() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let reasonsURL = documentsURL.appendingPathComponent("reasons.csv")
        
        var csvContent = "Reason,Type\n"
        
        // Add sign-in reasons
        for reason in signInReasons {
            csvContent += "\(reason),In\n"
        }
        
        // Add sign-out reasons
        for reason in signOutReasons {
            csvContent += "\(reason),Out\n"
        }
        
        try? csvContent.write(to: reasonsURL, atomically: true, encoding: .utf8)
    }
    
    func importReasonsFromCSV(_ csvData: String) {
        parseReasonsFromCSV(csvData)
        saveReasonsToCSV()
    }
    
    func resetToDefaults() {
        setDefaultReasons()
        saveReasonsToCSV()
    }
} 