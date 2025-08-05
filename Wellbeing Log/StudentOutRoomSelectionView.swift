import SwiftUI

struct StudentOutRoomSelectionView: View {
    @ObservedObject var studentStore: StudentStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(spacing: isIPad ? 50 : 30) {
            Text("Student Out - Select Room")
                .font(.system(size: isIPad ? 48 : 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, isIPad ? 50 : 30)
                .padding(.bottom, isIPad ? 20 : 10)
                .multilineTextAlignment(.center)
            
            VStack(spacing: isIPad ? 40 : 20) {
                NavigationLink(destination: StudentOutSearchView(studentStore: studentStore, roomType: .wellbeing)) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: isIPad ? 32 : 24))
                            .foregroundColor(.white)
                        
                        Text("Wellbeing Room")
                            .font(isIPad ? .largeTitle : .title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 100 : 60)
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, isIPad ? 40 : 20)
                
                NavigationLink(destination: StudentOutSearchView(studentStore: studentStore, roomType: .diverseLearners)) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: isIPad ? 32 : 24))
                            .foregroundColor(.white)
                        
                        Text("Diverse Learners Room")
                            .font(isIPad ? .largeTitle : .title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 100 : 60)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, isIPad ? 40 : 20)
                
                NavigationLink(destination: LunchRoomOutView(studentStore: studentStore)) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: isIPad ? 32 : 24))
                            .foregroundColor(.white)
                        
                        Text("Lunch Room")
                            .font(isIPad ? .largeTitle : .title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 100 : 60)
                    .background(Color.orange)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, isIPad ? 40 : 20)
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 