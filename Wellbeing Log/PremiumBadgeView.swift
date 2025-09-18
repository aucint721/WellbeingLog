import SwiftUI

struct PremiumBadgeView: View {
    let size: CGFloat
    
    init(size: CGFloat = 200) {
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Simple professional icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: size * 0.6, height: size * 0.6)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: size * 0.3))
                    .foregroundColor(.blue)
            }
            
            // Simple text
            VStack(spacing: 8) {
                Text("Premium")
                    .font(.system(size: size * 0.12, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Wellbeing Log")
                    .font(.system(size: size * 0.08, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text("$9.99 one-time")
                    .font(.system(size: size * 0.06, weight: .semibold))
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
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
