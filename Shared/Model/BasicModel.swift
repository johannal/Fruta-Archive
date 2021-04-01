//
// BasicModel
// Fruta
//

import Combine

typealias FrutaModel = BasicModel

class BasicModel: Model {
    @Published var order: Order?
    
    @Published var account: Account?
    var hasAccount: Bool { account != nil }
    
    @Published var favoriteSmoothieIDs = Set<Smoothie.ID>()
    
    @Published var isApplePayEnabled = false
    @Published var allRecipesUnlocked = true
}
