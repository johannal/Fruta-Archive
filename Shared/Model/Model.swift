//
//  Model
//  Fruta
//

import Combine

// MARK: - Model

protocol Model: ObservableObject {
    var order: Order? { get set }
    var account: Account? { get set }
    var hasAccount: Bool { get }
    
    var favoriteSmoothieIDs: Set<Smoothie.ID> { get set }
    
    var isApplePayEnabled: Bool { get set }
    var allRecipesUnlocked: Bool { get set }
}

// MARK: - Common Methods

extension Model {
    func orderSmoothie(_ smoothie: Smoothie) {
        order = Order(smoothie: smoothie, points: 1, isReady: false)
        addOrderToAccount()
    }
    
    func redeemSmoothie(_ smoothie: Smoothie) {
        guard var account = account, account.canRedeemFreeSmoothie else { return }
        account.pointsSpent += 10
        self.account = account
        orderSmoothie(smoothie)
    }
    
    func orderReadyForPickup() {
        order?.isReady = true
    }
    
    func toggleFavorite(smoothie: Smoothie) {
        if favoriteSmoothieIDs.contains(smoothie.id) {
            favoriteSmoothieIDs.remove(smoothie.id)
        } else {
            favoriteSmoothieIDs.insert(smoothie.id)
        }
    }
    
    func isFavorite(smoothie: Smoothie) -> Bool {
        favoriteSmoothieIDs.contains(smoothie.id)
    }
    
    func createAccount() {
        guard account == nil else { return }
        account = Account()
        addOrderToAccount()
    }
    
    func addOrderToAccount() {
        guard let order = order else { return }
        account?.appendOrder(order)
    }
    
    func clearUnstampedPoints() {
        account?.clearUnstampedPoints()
    }
}
