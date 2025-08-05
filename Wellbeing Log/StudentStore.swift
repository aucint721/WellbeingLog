import Foundation
import SwiftUI

class StudentStore: ObservableObject {
    @Published var students: [Student] = [] {
        didSet {
            // Auto-save whenever students array changes
            saveStudents()
        }
    }

    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        loadStudents()
    }
    
    func loadStudents() {
        isLoading = true
        hasError = false
        
        // First, try to load from saved file in documents directory
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let savedStudentsURL = documentsURL.appendingPathComponent("students.csv")
            
            if FileManager.default.fileExists(atPath: savedStudentsURL.path) {
                if let data = try? String(contentsOf: savedStudentsURL, encoding: .utf8) {
                    loadCSV(from: data)
                    isLoading = false
                    return
                }
            }
        }
        
        // Try to load directly from Student.csv in app bundle
        if let bundlePath = Bundle.main.path(forResource: "Student", ofType: "csv") {
            
            do {
                let data = try String(contentsOf: URL(fileURLWithPath: bundlePath), encoding: .utf8)
                
                // Simple CSV parsing for testing
                let lines = data.components(separatedBy: .newlines)
                
                if lines.count > 1 {
                    // Skip header row and parse each line
                    for (_, line) in lines.dropFirst().enumerated() {
                        if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            continue
                        }
                        
                        let columns = line.components(separatedBy: ",")
                        if columns.count >= 5 {
                            let name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                            let surname = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            let year = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)
                            let teacher = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                            let imageData = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            let student = Student(
                                firstName: name,
                                lastName: surname,
                                year: year,
                                teacher: teacher,
                                imageData: imageData
                            )
                            
                            students.append(student)
                        }
                    }
                }
                
                isLoading = false
                return
                
            } catch {
                hasError = true
                errorMessage = "Failed to load student data: \(error.localizedDescription)"
                isLoading = false
            }
        } else {
            hasError = true
            errorMessage = "Student data file not found. Please import student data from Settings."
            isLoading = false
        }
        
        // Fallback to sample data if Student.csv not found
        loadSampleData()
        isLoading = false
    }
    
    func loadSampleData() {
        // Try to load from sample_students.csv in app bundle
        if let bundlePath = Bundle.main.path(forResource: "sample_students", ofType: "csv") {
            if let data = try? String(contentsOf: URL(fileURLWithPath: bundlePath), encoding: .utf8) {
                loadCSV(from: data)
                return
            }
        }
        
        // Try to load from Student.csv in app bundle
        if let bundlePath = Bundle.main.path(forResource: "Student", ofType: "csv") {
            if let data = try? String(contentsOf: URL(fileURLWithPath: bundlePath), encoding: .utf8) {
                loadCSV(from: data)
                return
            }
        }
    }
    
    func loadCSV(from csvString: String) {
        students.removeAll()
        
        // Split by lines but be careful with multi-line fields
        let lines = csvString.components(separatedBy: .newlines)
        
        guard lines.count > 1 else { 
            hasError = true
            errorMessage = "CSV file is empty or invalid"
            return 
        }
        
        // Skip header row
        for (_, line) in lines.dropFirst().enumerated() {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue // Skip empty lines
            }
            
            // Parse the line, handling potential multi-line base64 data
            let columns = parseCSVLine(line)
            
            guard columns.count >= 5 else {
                continue
            }
            
            let name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let surname = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let year = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)
            let teacher = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
            let imageData = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let student = Student(
                firstName: name,
                lastName: surname,
                year: year,
                teacher: teacher,
                imageData: imageData
            )
            
            students.append(student)
        }
        
        hasError = false
        errorMessage = ""
    }
    
    private func parseCSVLine(_ line: String) -> [String] {
        var columns: [String] = []
        var currentField = ""
        var inQuotes = false
        var i = 0
        
        while i < line.count {
            let char = line[line.index(line.startIndex, offsetBy: i)]
            
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                let trimmedField = currentField.trimmingCharacters(in: .whitespacesAndNewlines)
                columns.append(trimmedField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            i += 1
        }
        
        // Add the last field
        let trimmedField = currentField.trimmingCharacters(in: .whitespacesAndNewlines)
        columns.append(trimmedField)
        
        return columns
    }
    
    // Alternative CSV parser that handles base64 data better
    private func parseCSVLineWithBase64(_ line: String) -> [String] {
        // Split by the first 4 commas only, then treat the rest as one field
        let components = line.components(separatedBy: ",")
        
        guard components.count >= 4 else {
            return components
        }
        
        var result: [String] = []
        
        // Add the first 4 columns (Name, Surname, Year, Teacher)
        for i in 0..<4 {
            result.append(components[i].trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        // Combine all remaining components as the Image data
        if components.count > 4 {
            let imageData = components.dropFirst(4).joined(separator: ",")
            result.append(imageData.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return result
    }
    
    func saveStudents() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else { return }
        
        let csvURL = documentsURL.appendingPathComponent("students.csv")
        
        var csvString = "Name,Surname,Year,Teacher,Image\n"
        for student in students {
            csvString += "\(student.firstName),\(student.lastName),\(student.year),\(student.teacher),\(student.imageData ?? "")\n"
        }
        
        try? csvString.write(to: csvURL, atomically: true, encoding: .utf8)
    }
}
