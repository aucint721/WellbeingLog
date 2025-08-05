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
    
    // MARK: - Debug Methods (Remove for production)
    
    #if DEBUG
    func simulateTrialExpiration() {
        // Set trial start date to 31 days ago to simulate expired trial
        let expiredDate = Calendar.current.date(byAdding: .day, value: -31, to: Date()) ?? Date()
        UserDefaults.standard.set(expiredDate, forKey: "trialStartDate")
        Task {
            await checkTrialStatus()
        }
    }
    
    func resetTrial() {
        // Reset trial to start fresh
        UserDefaults.standard.removeObject(forKey: "trialStartDate")
        Task {
            await checkTrialStatus()
        }
    }
    
    func simulatePurchase() {
        // Simulate a successful purchase for testing
        isPurchased = true
        isInTrial = false
        trialDaysRemaining = 0
    }
    #endif
} 