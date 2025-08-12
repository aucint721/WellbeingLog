import Foundation
import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var isPurchased = false
    @Published var isInTrial = false
    @Published var trialDaysRemaining = 30
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productID = "wellbeing_log_premium"
    private var products: [Product] = []
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchaseStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: [productID])
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
    }
    
    func purchase() async {
        guard let product = products.first else {
            errorMessage = "Product not available"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                await handlePurchaseSuccess(verification)
            case .userCancelled:
                errorMessage = "Purchase cancelled"
            case .pending:
                errorMessage = "Purchase pending"
            @unknown default:
                errorMessage = "Unknown purchase result"
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func handlePurchaseSuccess(_ verification: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = verification else {
            errorMessage = "Transaction verification failed"
            return
        }
        
        await transaction.finish()
        await updatePurchaseStatus()
    }
    
    func updatePurchaseStatus() async {
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productID == productID {
                isPurchased = true
                isInTrial = false
                return
            }
        }
        
        // Check if user is in trial period
        await checkTrialStatus()
    }
    
    func checkTrialStatus() async {
        // For demo purposes, we'll use UserDefaults to track trial
        // In production, you'd want to use a more secure method
        let trialStartDate = UserDefaults.standard.object(forKey: "trialStartDate") as? Date
        
        if trialStartDate == nil {
            // First time user, start trial
            UserDefaults.standard.set(Date(), forKey: "trialStartDate")
            isInTrial = true
            trialDaysRemaining = 30
        } else {
            let daysSinceTrialStart = Calendar.current.dateComponents([.day], from: trialStartDate!, to: Date()).day ?? 0
            let remainingDays = max(0, 30 - daysSinceTrialStart)
            
            if remainingDays > 0 {
                isInTrial = true
                trialDaysRemaining = remainingDays
            } else {
                isInTrial = false
                trialDaysRemaining = 0
            }
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in StoreKit.Transaction.updates {
                await self.handlePurchaseSuccess(result)
            }
        }
    }
    
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var canUseApp: Bool {
        return isPurchased || isInTrial
    }
    
    var purchaseStatusText: String {
        if isPurchased {
            return "Premium Active"
        } else if isInTrial {
            return "Trial - \(trialDaysRemaining) days left"
        } else {
            return "Trial Expired"
        }
    }
    
    var productPrice: String {
        guard let product = products.first else { return "$9.99" }
        return product.displayPrice
    }
    
    // MARK: - Trial Information Methods
    
    var trialStartDate: Date? {
        return UserDefaults.standard.object(forKey: "trialStartDate") as? Date
    }
    
    var trialEndDate: Date? {
        guard let startDate = trialStartDate else { return nil }
        return Calendar.current.date(byAdding: .day, value: 30, to: startDate)
    }
    
    var trialStatusDescription: String {
        if isPurchased {
            return "Premium features unlocked"
        } else if isInTrial {
            return "Trial active - \(trialDaysRemaining) days remaining"
        } else {
            return "Trial expired - upgrade to continue"
        }
    }
    
    var trialProgressPercentage: Double {
        if isPurchased {
            return 1.0
        } else if isInTrial {
            return Double(30 - trialDaysRemaining) / 30.0
        } else {
            return 1.0
        }
    }
    
    var formattedTrialStartDate: String {
        guard let startDate = trialStartDate else { return "Not started" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
    
    var formattedTrialEndDate: String {
        guard let endDate = trialEndDate else { return "Not available" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: endDate)
    }
    
    var trialExpirationText: String {
        guard let endDate = trialEndDate else { return "Trial not started" }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: endDate)
        
        if let days = components.day {
            if days > 0 {
                if days == 1 {
                    return "Expires tomorrow"
                } else {
                    return "Expires in \(days) days"
                }
            } else if days == 0 {
                return "Expires today"
            } else {
                let expiredDays = abs(days)
                if expiredDays == 1 {
                    return "Expired yesterday"
                } else {
                    return "Expired \(expiredDays) days ago"
                }
            }
        }
        
        return "Expires on \(formattedTrialEndDate)"
    }
} 