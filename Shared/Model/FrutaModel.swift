//
//  FrutaModel.swift
//  Fruta
//

import Foundation
import StoreKit
import SwiftUI

class FrutaModel: ObservableObject {
    @Published var order: Order?
    @Published var account: Account?
    @Published var favoriteSmoothieIDs = Set<Smoothie.ID>()
    @Published var unlockedAllRecipes: Bool = false
    @Published var unlockAllRecipesProduct: SKProduct?
    @Published var highlightPopularSmoothiesNearby = false
    
    private let store = Store()
    
    init() {
        // Get notified when access to a product is revoked
        store.revocationDelegate = self
        store.fetchProducts { [weak self] products in
            guard let self = self else { return }
            self.unlockAllRecipesProduct = products.first(where: { $0.productIdentifier == Store.unlockAllRecipesIdentifier })
        }
    }
    
    var hasAccount: Bool { account != nil }
    
    func orderSmoothie(id smoothieID: Smoothie.ID) {
        order = Order(smoothieID: smoothieID, points: 1, isReady: false)
        addOrderToAccount()
    }
    
    func createAccount() {
        account = Account()
        addOrderToAccount()
    }
    
    func addOrderToAccount() {
        guard let order = order, var account = account else { return }
        account.orderHistory.append(order)
        account.unstampedPoints += order.points
        self.account = account
    }
    
    func purchaseProduct(_ product: SKProduct) {
        store.startObservingPaymentQueue()
        store.buy(product) { [weak self] transaction in
            guard let self = self,
                  let transaction = transaction else {
                return
            }
            
            // If the purchase was successful and it was for the premium recipes identifiers
            // then publish the unlock change
            if transaction.payment.productIdentifier == Store.unlockAllRecipesIdentifier,
               transaction.transactionState == .purchased {
                self.unlockedAllRecipes = true
            }
        }
    }
}

extension FrutaModel: StoreRevocationDelegate {
    func productIDsRevoked(productIDs: [String]) {
        if productIDs.contains(Store.unlockAllRecipesIdentifier) {
            unlockedAllRecipes = false
        }
    }
}
