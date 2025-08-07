import SwiftUI

struct StatisticsData {
    var wellbeingRoom: RoomStats = RoomStats()
    var diverseLearnersRoom: RoomStats = RoomStats()
    var lunchRoom: RoomStats = RoomStats()
    var totalStudents: Int = 0
}

struct RoomStats {
    var todaySignedIn: Int = 0
    var todayEntries: Int = 0
    var currentlyInRoom: Int = 0
    var averageTimeInMinutes: Double = 0.0
    var topEntryReasons: [(reason: String, count: Int)] = []
    var topOutcomes: [(outcome: String, count: Int)] = []
    var frequentVisitors: [(name: String, visits: Int)] = []
    var weeklyTrend: [String: Int] = [:]
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color
    
    init(label: String, value: String, color: Color = .primary) {
        self.label = label
        self.value = value
        self.color = color
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

struct StatisticsCard<Content: View>: View {
    let title: String
    let color: Color
    let content: Content
    
    init(title: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Spacer()
            }
            
            content
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

struct StatisticsView: View {
    @ObservedObject var studentStore: StudentStore
    @State private var statistics: StatisticsData = StatisticsData()
    @State private var isLoading = true
    @State private var hasError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Statistics")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                
                Button(action: {
                    loadStatistics()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
                .disabled(isLoading)
            }
            .padding(.top)
            
            if isLoading {
                VStack(spacing: 20) {
                    ProgressView("Loading statistics...")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Analyzing student data...")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding()
                Spacer()
            } else if hasError {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Error Loading Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(errorMessage)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        loadStatistics()
                    }) {
                        Text("Try Again")
                            .font(.title2)
                            .fontWeight(.bold)
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
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Wellbeing Room Statistics
                        StatisticsCard(title: "Wellbeing Room", color: .green) {
                            VStack(alignment: .leading, spacing: 8) {
                                StatRow(label: "Students signed in today", value: "\(statistics.wellbeingRoom.todaySignedIn)", color: .green)
                                StatRow(label: "Total entries today", value: "\(statistics.wellbeingRoom.todayEntries)", color: .green)
                                StatRow(label: "Currently in room", value: "\(statistics.wellbeingRoom.currentlyInRoom)", color: .green)
                                StatRow(label: "Average time in room", value: formatAverageTime(statistics.wellbeingRoom.averageTimeInMinutes), color: .green)
                                
                                if !statistics.wellbeingRoom.topEntryReasons.isEmpty {
                                    Divider()
                                    Text("Most Common Reasons:")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    
                                    ForEach(statistics.wellbeingRoom.topEntryReasons.prefix(3), id: \.reason) { item in
                                        StatRow(label: item.reason, value: "\(item.count)", color: .green)
                                    }
                                }
                            }
                        }
                        
                        // Diverse Learners Room Statistics
                        StatisticsCard(title: "Diverse Learners Room", color: .blue) {
                            VStack(alignment: .leading, spacing: 8) {
                                StatRow(label: "Students signed in today", value: "\(statistics.diverseLearnersRoom.todaySignedIn)", color: .blue)
                                StatRow(label: "Total entries today", value: "\(statistics.diverseLearnersRoom.todayEntries)", color: .blue)
                                StatRow(label: "Currently in room", value: "\(statistics.diverseLearnersRoom.currentlyInRoom)", color: .blue)
                                StatRow(label: "Average time in room", value: formatAverageTime(statistics.diverseLearnersRoom.averageTimeInMinutes), color: .blue)
                                
                                if !statistics.diverseLearnersRoom.topEntryReasons.isEmpty {
                                    Divider()
                                    Text("Most Common Reasons:")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    ForEach(statistics.diverseLearnersRoom.topEntryReasons.prefix(3), id: \.reason) { item in
                                        StatRow(label: item.reason, value: "\(item.count)", color: .blue)
                                    }
                                }
                            }
                        }
                        
                        // Lunch Room Statistics
                        StatisticsCard(title: "Lunch Room", color: .orange) {
                            VStack(alignment: .leading, spacing: 8) {
                                StatRow(label: "Students signed in today", value: "\(statistics.lunchRoom.todaySignedIn)", color: .orange)
                                StatRow(label: "Total entries today", value: "\(statistics.lunchRoom.todayEntries)", color: .orange)
                                StatRow(label: "Currently in room", value: "\(statistics.lunchRoom.currentlyInRoom)", color: .orange)
                                StatRow(label: "Average time in room", value: formatAverageTime(statistics.lunchRoom.averageTimeInMinutes), color: .orange)
                                
                                if !statistics.lunchRoom.topEntryReasons.isEmpty {
                                    Divider()
                                    Text("Most Common Reasons:")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    
                                    ForEach(statistics.lunchRoom.topEntryReasons.prefix(3), id: \.reason) { item in
                                        StatRow(label: item.reason, value: "\(item.count)", color: .orange)
                                    }
                                }
                            }
                        }
                        
                        // Overall Summary
                        StatisticsCard(title: "Overall Summary", color: .purple) {
                            VStack(alignment: .leading, spacing: 8) {
                                let totalToday = statistics.wellbeingRoom.todaySignedIn + statistics.diverseLearnersRoom.todaySignedIn + statistics.lunchRoom.todaySignedIn
                                let totalCurrently = statistics.wellbeingRoom.currentlyInRoom + statistics.diverseLearnersRoom.currentlyInRoom + statistics.lunchRoom.currentlyInRoom
                                let totalEntries = statistics.wellbeingRoom.todayEntries + statistics.diverseLearnersRoom.todayEntries + statistics.lunchRoom.todayEntries
                                
                                StatRow(label: "Total students signed in today", value: "\(totalToday)", color: .purple)
                                StatRow(label: "Total entries today", value: "\(totalEntries)", color: .purple)
                                StatRow(label: "Total currently in rooms", value: "\(totalCurrently)", color: .purple)
                                StatRow(label: "Total students in system", value: "\(statistics.totalStudents)", color: .purple)
                            }
                        }
                        
                        // No Data Message
                        if statistics.wellbeingRoom.todaySignedIn == 0 && statistics.diverseLearnersRoom.todaySignedIn == 0 && statistics.lunchRoom.todaySignedIn == 0 {
                            VStack(spacing: 15) {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("No Data Available")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                
                                Text("Start signing students in to see statistics here.")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            loadStatistics()
        }
    }
    
    func loadStatistics() {
        isLoading = true
        hasError = false
        
        DispatchQueue.global(qos: .background).async {
            let stats = calculateStatistics()
            DispatchQueue.main.async {
                self.statistics = stats
                self.isLoading = false
            }
        }
    }
    
    func calculateStatistics() -> StatisticsData {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first else {
            hasError = true
            errorMessage = "Could not access documents directory"
            return StatisticsData()
        }
        
        let logURL = documentsURL.appendingPathComponent("StudentEntryLog.csv")
        guard let data = try? String(contentsOf: logURL, encoding: .utf8) else {
            hasError = true
            errorMessage = "No log data found. Start signing students in to generate statistics."
            return StatisticsData()
        }
        
        let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard rows.count > 1 else {
            hasError = true
            errorMessage = "Log file is empty. Please sign in some students first."
            return StatisticsData()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today = Date()
        let calendar = Calendar.current
        
        // Track statistics for each room
        var wellbeingStats = RoomStats()
        var diverseLearnersStats = RoomStats()
        var lunchStats = RoomStats()
        
        _ = [
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
        
        // Track entries by room
        var wellbeingEntries: [String: [(action: String, timestamp: Date, reason: String)]] = [:]
        var diverseLearnersEntries: [String: [(action: String, timestamp: Date, reason: String)]] = [:]
        var lunchEntries: [String: [(action: String, timestamp: Date, reason: String)]] = [:]
        
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
                    room = "Unknown" // Use unknown for old format
                    dateString = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                }
            } else if columns.count >= 5 {
                // Old format without room - assume it's for the current room
                name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                reason = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
                room = "Unknown" // Use unknown for old format
                dateString = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                continue
            }
            
            // Parse timestamp safely
            guard let timestamp = formatter.date(from: dateString) else { continue }
            
            // Determine action type
            let signInReasons = ["Anxiety/Stress", "Friendship Issues", "Sensory Overload", "Academic Stress", "Family Issues", "Need Quiet Time", "Medical Issue", "Counseling Session", "Other In"]
            let signOutReasons = ["Feeling Better", "Return to Class", "Going to Lunch", "Going to Recess", "Going to Library", "Going to Office", "Going to Nurse", "Going to Counselor", "Medical Appointment", "Parent Contact", "Going Home", "Other Out"]
            
            var action = "UNKNOWN"
            if signInReasons.contains(reason) {
                action = "SIGN_IN"
            } else if signOutReasons.contains(reason) {
                action = "SIGN_OUT"
            } else {
                action = "SIGN_IN" // Default to sign-in for safety
            }
            
            // Store entry with timestamp and room
            if room == "Wellbeing Room" {
                if wellbeingEntries[name] == nil {
                    wellbeingEntries[name] = []
                }
                wellbeingEntries[name]?.append((action: action, timestamp: timestamp, reason: reason))
                
                // Track today's entries
                if calendar.isDate(timestamp, inSameDayAs: today) {
                    wellbeingStats.todayEntries += 1
                    if action == "SIGN_IN" {
                        wellbeingStats.todaySignedIn += 1
                    }
                }
                
                // Track weekly trend
                let weekday = calendar.component(.weekday, from: timestamp)
                let weekdayName = calendar.weekdaySymbols[weekday - 1]
                wellbeingStats.weeklyTrend[weekdayName, default: 0] += 1
                
            } else if room == "Diverse Learners Room" {
                if diverseLearnersEntries[name] == nil {
                    diverseLearnersEntries[name] = []
                }
                diverseLearnersEntries[name]?.append((action: action, timestamp: timestamp, reason: reason))
                
                // Track today's entries
                if calendar.isDate(timestamp, inSameDayAs: today) {
                    diverseLearnersStats.todayEntries += 1
                    if action == "SIGN_IN" {
                        diverseLearnersStats.todaySignedIn += 1
                    }
                }
                
                // Track weekly trend
                let weekday = calendar.component(.weekday, from: timestamp)
                let weekdayName = calendar.weekdaySymbols[weekday - 1]
                diverseLearnersStats.weeklyTrend[weekdayName, default: 0] += 1
                
            } else if room == "Lunch Room" {
                if lunchEntries[name] == nil {
                    lunchEntries[name] = []
                }
                lunchEntries[name]?.append((action: action, timestamp: timestamp, reason: reason))
                
                // Track today's entries
                if calendar.isDate(timestamp, inSameDayAs: today) {
                    lunchStats.todayEntries += 1
                    if action == "SIGN_IN" {
                        lunchStats.todaySignedIn += 1
                    }
                }
                
                // Track weekly trend
                let weekday = calendar.component(.weekday, from: timestamp)
                let weekdayName = calendar.weekdaySymbols[weekday - 1]
                lunchStats.weeklyTrend[weekdayName, default: 0] += 1
            }
        }
        
        // Calculate currently in room for each room
        var currentlySignedInWellbeing: [String] = []
        var currentlySignedInDiverseLearners: [String] = []
        var currentlySignedInLunch: [String] = []
        
        // Wellbeing Room
        for (studentName, entries) in wellbeingEntries {
            guard !entries.isEmpty else { continue }
            
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            guard let lastEntry = sortedEntries.last else { continue }
            
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInWellbeing.append(studentName)
            }
        }
        
        // Diverse Learners Room
        for (studentName, entries) in diverseLearnersEntries {
            guard !entries.isEmpty else { continue }
            
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            guard let lastEntry = sortedEntries.last else { continue }
            
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInDiverseLearners.append(studentName)
            }
        }
        
        // Lunch Room
        for (studentName, entries) in lunchEntries {
            guard !entries.isEmpty else { continue }
            
            let sortedEntries = entries.sorted { $0.timestamp < $1.timestamp }
            guard let lastEntry = sortedEntries.last else { continue }
            
            if lastEntry.action == "SIGN_IN" {
                currentlySignedInLunch.append(studentName)
            }
        }
        
        wellbeingStats.currentlyInRoom = currentlySignedInWellbeing.count
        diverseLearnersStats.currentlyInRoom = currentlySignedInDiverseLearners.count
        lunchStats.currentlyInRoom = currentlySignedInLunch.count
        
        // Calculate average time in room for each room
        wellbeingStats.averageTimeInMinutes = calculateAverageTimeInRoom(wellbeingEntries)
        diverseLearnersStats.averageTimeInMinutes = calculateAverageTimeInRoom(diverseLearnersEntries)
        lunchStats.averageTimeInMinutes = calculateAverageTimeInRoom(lunchEntries)
        
        return StatisticsData(
            wellbeingRoom: wellbeingStats,
            diverseLearnersRoom: diverseLearnersStats,
            lunchRoom: lunchStats,
            totalStudents: studentStore.students.count
        )
    }
    
    private func calculateAverageTimeInRoom(_ entries: [String: [(action: String, timestamp: Date, reason: String)]]) -> Double {
        var totalTimeInMinutes: Double = 0
        var completedSessions = 0
        
        for (_, studentEntries) in entries {
            let sortedEntries = studentEntries.sorted { $0.timestamp < $1.timestamp }
            
            // Group entries into sessions (sign-in followed by sign-out)
            var i = 0
            while i < sortedEntries.count - 1 {
                let currentEntry = sortedEntries[i]
                let nextEntry = sortedEntries[i + 1]
                
                if currentEntry.action == "SIGN_IN" && nextEntry.action == "SIGN_OUT" {
                    let timeDifference = nextEntry.timestamp.timeIntervalSince(currentEntry.timestamp)
                    let minutes = timeDifference / 60.0
                    totalTimeInMinutes += minutes
                    completedSessions += 1
                    i += 2 // Skip the next entry since we've processed it
                } else {
                    i += 1
                }
            }
        }
        
        return completedSessions > 0 ? totalTimeInMinutes / Double(completedSessions) : 0.0
    }
    
    private func formatAverageTime(_ minutes: Double) -> String {
        if minutes == 0 {
            return "No data"
        } else if minutes < 60 {
            return "\(Int(minutes)) min"
        } else {
            let hours = Int(minutes / 60)
            let remainingMinutes = Int(minutes.truncatingRemainder(dividingBy: 60))
            if remainingMinutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(remainingMinutes)m"
            }
        }
    }
}
