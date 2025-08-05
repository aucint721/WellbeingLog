import SwiftUI
import StoreKit

struct PurchaseView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text("Unlock Premium Features")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Your 30-day free trial has ended. Upgrade to continue using all features.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Features list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Premium Features:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    FeatureRow(icon: "person.2.fill", text: "Unlimited student tracking")
                    FeatureRow(icon: "chart.bar.fill", text: "Advanced statistics and reports")
                    FeatureRow(icon: "folder.fill", text: "Custom reason management")
                    FeatureRow(icon: "square.and.arrow.up", text: "Export and backup data")
                    FeatureRow(icon: "icloud.fill", text: "Data persistence across devices")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Purchase button
                VStack(spacing: 16) {
                    Button(action: {
                        Task {
                            await subscriptionManager.purchase()
                        }
                    }) {
                        HStack {
                            if subscriptionManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Upgrade to Premium")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(subscriptionManager.isLoading)
                    
                    Button("Restore Purchases") {
                        Task {
                            await subscriptionManager.restorePurchases()
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                // Terms and privacy
                VStack(spacing: 8) {
                    Text("By purchasing, you agree to our Terms of Service and Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button("Terms of Service") {
                            // Open terms
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Button("Privacy Policy") {
                            // Open privacy policy
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .navigationTitle("Premium Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Purchase Error", isPresented: .constant(subscriptionManager.errorMessage != nil)) {
            Button("OK") {
                subscriptionManager.errorMessage = nil
            }
        } message: {
            if let errorMessage = subscriptionManager.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
    }
}

#Preview {
    PurchaseView()
        .environmentObject(SubscriptionManager())
} 