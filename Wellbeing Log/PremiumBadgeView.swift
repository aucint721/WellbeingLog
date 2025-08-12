import SwiftUI

struct PremiumBadgeView: View {
    let size: CGFloat
    
    init(size: CGFloat = 200) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: size * 0.12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.49, blue: 0.92), // #667eea
                            Color(red: 0.46, green: 0.29, blue: 0.64)  // #764ba2
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.3), radius: size * 0.02, x: 0, y: size * 0.02)
            
            // Shine effect
            RoundedRectangle(cornerRadius: size * 0.12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: UUID())
            
            VStack(spacing: size * 0.05) {
                // App Logo (Heart)
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.05)
                        .fill(Color.white.opacity(0.95))
                        .frame(width: size * 0.28, height: size * 0.28)
                        .shadow(color: .black.opacity(0.2), radius: size * 0.01, x: 0, y: size * 0.01)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.12))
                        .foregroundColor(.red)
                }
                
                // Premium Text
                VStack(spacing: size * 0.025) {
                    Text("PREMIUM")
                        .font(.system(size: size * 0.08, weight: .black, design: .default))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: size * 0.004, x: 0, y: size * 0.004)
                        .kerning(-1)
                    
                    Text("Wellbeing Log")
                        .font(.system(size: size * 0.042, weight: .semibold, design: .default))
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.3), radius: size * 0.002, x: 0, y: size * 0.002)
                }
                
                // Feature Icons
                HStack(spacing: size * 0.06) {
                    FeatureIcon(icon: "chart.bar.fill", text: "Analytics", size: size)
                    FeatureIcon(icon: "icloud.fill", text: "CloudKit", size: size)
                    FeatureIcon(icon: "arrow.triangle.2.circlepath", text: "Sync", size: size)
                }
            }
            
            // Crown decoration
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "crown.fill")
                        .font(.system(size: size * 0.09))
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.3), radius: size * 0.004, x: 0, y: size * 0.004)
                        .padding(.trailing, size * 0.08)
                        .padding(.top, size * 0.08)
                }
                Spacer()
            }
            
            // Price tag
            VStack {
                HStack {
                    Text("$9.99")
                        .font(.system(size: size * 0.032, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, size * 0.035)
                        .padding(.vertical, size * 0.025)
                        .background(
                            RoundedRectangle(cornerRadius: size * 0.05)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.green,
                                            Color.green.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: size * 0.01, x: 0, y: size * 0.01)
                        .padding(.leading, size * 0.08)
                        .padding(.top, size * 0.08)
                    Spacer()
                }
                Spacer()
            }
            
            // Unlock badge
            VStack {
                Spacer()
                HStack {
                    Text("UNLOCK ALL")
                        .font(.system(size: size * 0.028, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                        .padding(.horizontal, size * 0.035)
                        .padding(.vertical, size * 0.025)
                        .background(
                            RoundedRectangle(cornerRadius: size * 0.05)
                                .fill(Color.white.opacity(0.95))
                        )
                        .shadow(color: .black.opacity(0.2), radius: size * 0.01, x: 0, y: size * 0.01)
                        .padding(.leading, size * 0.08)
                        .padding(.bottom, size * 0.08)
                    Spacer()
                }
            }
            
            // Premium star indicator
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.95))
                            .frame(width: size * 0.08, height: size * 0.08)
                            .shadow(color: .black.opacity(0.2), radius: size * 0.01, x: 0, y: size * 0.01)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: size * 0.024, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                    }
                    .padding(.trailing, size * 0.06)
                    .padding(.bottom, size * 0.06)
                }
            }
        }
    }
}

struct FeatureIcon: View {
    let icon: String
    let text: String
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: size * 0.015) {
            Image(systemName: icon)
                .font(.system(size: size * 0.056))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: size * 0.002, x: 0, y: size * 0.002)
            
            Text(text)
                .font(.system(size: size * 0.022, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: size * 0.001, x: 0, y: size * 0.001)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        PremiumBadgeView(size: 200)
        PremiumBadgeView(size: 150)
        PremiumBadgeView(size: 100)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
