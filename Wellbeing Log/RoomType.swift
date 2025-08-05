import Foundation

enum RoomType: String, CaseIterable {
    case wellbeing = "Wellbeing Room"
    case diverseLearners = "Diverse Learners Room"
    case lunch = "Lunch Room"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .wellbeing:
            return "heart.fill"
        case .diverseLearners:
            return "brain.head.profile"
        case .lunch:
            return "fork.knife"
        }
    }
    
    var color: String {
        switch self {
        case .wellbeing:
            return "green"
        case .diverseLearners:
            return "blue"
        case .lunch:
            return "orange"
        }
    }
} 