import SwiftUI

struct LiveRoomSyncView: View {
    @StateObject private var syncManager = RoomSyncManager()
    @ObservedObject var studentStore: StudentStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: isIPad ? 40 : 20) {
                    // Header
                    VStack(spacing: 15) {
                                                                    Text("CloudKit Room Sync")
                            .font(.system(size: isIPad ? 56 : 36, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Real-time sync via iCloud (requires iCloud sign-in)")
                            .font(.system(size: isIPad ? 24 : 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, isIPad ? 40 : 20)
                    
                    // Room Counts Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: isIPad ? 30 : 20) {
                        // Wellbeing Room
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                Text("Wellbeing Room")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Spacer()
                            }
                            
                            Text("\(syncManager.wellbeingCount)")
                                .font(.system(size: isIPad ? 72 : 48, weight: .bold, design: .rounded))
                                .foregroundColor(.green)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.green.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.green, lineWidth: 2)
                                        )
                                )
                            
                            Text("Students Currently in Room")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Diverse Learners Room
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                Text("Diverse Learners Room")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            
                            Text("\(syncManager.diverseLearnersCount)")
                                .font(.system(size: isIPad ? 72 : 48, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                )
                            
                            Text("Students Currently in Room")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Lunch Room
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                Text("Lunch Room")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                Spacer()
                            }
                            
                            Text("\(syncManager.lunchCount)")
                                .font(.system(size: isIPad ? 72 : 48, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.orange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.orange, lineWidth: 2)
                                        )
                                )
                            
                            Text("Students Currently in Room")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Sync Status and Controls
                    VStack(spacing: 15) {
                        // Connection Status
                        HStack {
                            Image(systemName: syncManager.isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(syncManager.isConnected ? .green : .red)
                            Text(syncManager.isConnected ? "iCloud Connected" : "iCloud Disconnected")
                                .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                        }
                        
                        if let error = syncManager.syncError {
                            Text("Error: \(error)")
                                .font(.system(size: isIPad ? 16 : 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        Text("Last sync: \(syncManager.lastSyncTime, style: .time)")
                            .font(.system(size: isIPad ? 16 : 14))
                            .foregroundColor(.secondary)
                        
                        // Manual sync button
                        Button("Manual Sync Now") {
                            syncManager.forceSync()
                        }
                        .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    Spacer(minLength: isIPad ? 100 : 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Refresh counts when view appears
            syncManager.loadCurrentCounts()
        }
    }
    
    // Simplified for testing
}

// MARK: - Connection Status View

struct ConnectionStatusView: View {
    @ObservedObject var syncManager: RoomSyncManager
    
    var body: some View {
        HStack(spacing: 15) {
            // Local Mode Indicator
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                
                Text("Local Mode")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            // Last Save Time
            VStack(alignment: .leading, spacing: 2) {
                Text("Last Save")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(syncManager.lastSyncTime, style: .time)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Room Count Card

struct RoomCountCard: View {
    let roomType: RoomType
    let count: Int
    @ObservedObject var syncManager: RoomSyncManager
    
    var body: some View {
        VStack(spacing: 15) {
            // Room Icon and Name
            HStack {
                Image(systemName: roomType.icon)
                    .foregroundColor(roomType.color)
                    .font(.title2)
                
                Text(roomType.displayName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(roomType.color)
                
                Spacer()
            }
            
            // Count Display
            Text("\(count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(roomType.color)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(roomType.color.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(roomType.color, lineWidth: 2)
                        )
                )
            
            // Status Text
            Text("Students Currently in Room")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Sync Controls View

struct SyncControlsView: View {
    @ObservedObject var syncManager: RoomSyncManager
    
    var body: some View {
        VStack(spacing: 15) {
            if let error = syncManager.syncError {
                Text("Sync Error: \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack(spacing: 20) {
                Button("Save Now") {
                    syncManager.forceSync()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Refresh") {
                    syncManager.forceSync()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

// MARK: - Activity Log View

struct ActivityLogView: View {
    @ObservedObject var syncManager: RoomSyncManager
    @State private var activities: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(activities, id: \.self) { activity in
                        Text(activity)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: 100)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Preview

struct LiveRoomSyncView_Previews: PreviewProvider {
    static var previews: some View {
        LiveRoomSyncView(studentStore: StudentStore())
    }
}
