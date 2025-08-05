import Foundation
import SwiftUI

struct Student: Identifiable, Hashable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let year: String
    let teacher: String
    let imageData: String? // Base64 encoded image data
    
    init(firstName: String, lastName: String, year: String, teacher: String, imageData: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.year = year
        self.teacher = teacher
        self.imageData = imageData
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Convert base64 data to SwiftUI Image
    var displayImage: Image? {
        guard let imageData = imageData else { 
            return nil 
        }
        
        // Remove data URI prefix if present
        let cleanData: String
        if imageData.hasPrefix("data:image/") {
            // Find the comma after the base64 part
            if let commaIndex = imageData.firstIndex(of: ",") {
                cleanData = String(imageData[imageData.index(after: commaIndex)...])
            } else {
                cleanData = imageData
            }
        } else {
            cleanData = imageData
        }
        
        guard let data = Data(base64Encoded: cleanData) else {
            return nil
        }
        
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(year)
        hasher.combine(teacher)
    }
    
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.firstName == rhs.firstName && 
               lhs.lastName == rhs.lastName && 
               lhs.year == rhs.year && 
               lhs.teacher == rhs.teacher
    }
}
