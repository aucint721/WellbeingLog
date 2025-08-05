import SwiftUI

@main
struct Wellbeing_LogApp: App {
    @StateObject private var studentStore = StudentStore()
    @StateObject private var reasonStore = ReasonStore()
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(studentStore)
                .environmentObject(reasonStore)
                .environmentObject(subscriptionManager)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // Save all data when app goes to background
                    studentStore.saveStudents()
                    reasonStore.saveReasonsToCSV()
                    saveAllCriticalData()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    // Additional save when app enters background
                    studentStore.saveStudents()
                    reasonStore.saveReasonsToCSV()
                    saveAllCriticalData()
                }
        }
    }
    
    private func saveAllCriticalData() {
        // Force save all critical data to ensure nothing is lost
        studentStore.saveStudents()
        reasonStore.saveReasonsToCSV()
        
        // Also ensure any pending file operations are completed
        // This is handled by the individual save functions
    }
}
