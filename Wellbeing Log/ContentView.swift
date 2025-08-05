import SwiftUI
import UniformTypeIdentifiers

enum MainMenuDestination: Hashable {
    case studentIn
    case studentOut
    case studentInRoomSelection
    case studentOutRoomSelection
    case wellbeingRoomIn
    case diverseLearnersRoomIn
    case lunchRoomIn
    case wellbeingRoomOut
    case diverseLearnersRoomOut
    case lunchRoomOut
    case settings
    case headCount
    case statistics
}

struct ContentView: View {
    @EnvironmentObject var studentStore: StudentStore
    @EnvironmentObject var reasonStore: ReasonStore
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var path: [MainMenuDestination] = []
    @State private var showingPurchaseView = false

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 50) {
                Text("Well App")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // Subscription status indicator
                HStack {
                    Text(subscriptionManager.purchaseStatusText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                VStack(spacing: 30) {
                    Button("Student In") {
                        if subscriptionManager.canUseApp {
                            path.append(.studentInRoomSelection)
                        } else {
                            showingPurchaseView = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)

                    Button("Student Out") {
                        if subscriptionManager.canUseApp {
                            path.append(.studentOutRoomSelection)
                        } else {
                            showingPurchaseView = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)

                    Button("Statistics") {
                        if subscriptionManager.canUseApp {
                            path.append(.statistics)
                        } else {
                            showingPurchaseView = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)

                    Button("Head Count") {
                        if subscriptionManager.canUseApp {
                            path.append(.headCount)
                        } else {
                            showingPurchaseView = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)

                    Button("Settings") {
                        path.append(.settings)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)


                }
                
                Spacer()
            }
            .navigationDestination(for: MainMenuDestination.self) { destination in
                switch destination {
                case .studentIn:
                    StudentInSearchView(studentStore: studentStore, roomType: .wellbeing)
                case .studentOut:
                    StudentOutSearchView(studentStore: studentStore, roomType: .wellbeing)
                case .studentInRoomSelection:
                    StudentInRoomSelectionView(studentStore: studentStore)
                case .studentOutRoomSelection:
                    StudentOutRoomSelectionView(studentStore: studentStore)
                case .wellbeingRoomIn:
                    StudentInSearchView(studentStore: studentStore, roomType: .wellbeing)
                case .diverseLearnersRoomIn:
                    StudentInSearchView(studentStore: studentStore, roomType: .diverseLearners)
                case .lunchRoomIn:
                    LunchRoomInView(studentStore: studentStore)
                case .wellbeingRoomOut:
                    StudentOutSearchView(studentStore: studentStore, roomType: .wellbeing)
                case .diverseLearnersRoomOut:
                    StudentOutSearchView(studentStore: studentStore, roomType: .diverseLearners)
                case .lunchRoomOut:
                    LunchRoomOutView(studentStore: studentStore)
                case .statistics:
                    StatisticsView(studentStore: studentStore)
                case .headCount:
                    HeadCountView(studentStore: studentStore)
                case .settings:
                    SettingsView(studentStore: studentStore)

                }
            }
        }
        .sheet(isPresented: $showingPurchaseView) {
            PurchaseView()
        }
        .onAppear {
            // Check subscription status when app appears
            Task {
                await subscriptionManager.updatePurchaseStatus()
            }
        }
    }
}
