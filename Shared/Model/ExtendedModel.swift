//
// ExtendedModel
// FrutaExpanded
//

import Combine
import AuthenticationServices
import StoreKit

typealias FrutaModel = ExtendedModel

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class ExtendedModel: NSObject, Model {
    @Published var order: Order?
    @Published var account: Account?
    
    var hasAccount: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return userCredential != nil && account != nil
        #endif
    }
    
    @Published var favoriteSmoothieIDs = Set<Smoothie.ID>()
    
    @Published var isApplePayEnabled = true
    @Published var allRecipesUnlocked = false
    @Published var unlockAllRecipesProduct: SKProduct?
    
    let defaults = UserDefaults(suiteName: "group.example.fruta-extended")
    
    private var userCredential: String? {
        get { defaults?.string(forKey: "UserCredential") }
        set { defaults?.setValue(newValue, forKey: "UserCredential") }
    }
    
    private let allProductIdentifiers = Set([ExtendedModel.unlockAllRecipesIdentifier])
    
    private var completedPurchases = [String]()
    private var fetchedProducts = [SKProduct]()
    private var productsRequest: SKProductsRequest?
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    override init() {
        super.init()
        // Get notified when access to a product is revoked
        startObservingPaymentQueue()
        fetchProducts { [weak self] products in
            guard let self = self else { return }
            self.unlockAllRecipesProduct = products.first(where: { $0.productIdentifier == ExtendedModel.unlockAllRecipesIdentifier })
        }
        
        guard let user = userCredential else { return }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: user) { state, error in
            if state == .authorized || state == .transferred {
                DispatchQueue.main.async {
                    self.createAccount()
                }
            }
        }
    }
    
    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result, let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            if case .failure(let error) = result {
                print("Authentication error: \(error.localizedDescription)")
            }
            return
        }
        DispatchQueue.main.async {
            self.userCredential = credential.user
            self.createAccount()
        }
    }
}

// MARK: - Store API

extension ExtendedModel {
    static let unlockAllRecipesIdentifier = "com.example.apple-samplecode.fruta.unlock-recipes"
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier })
    }
    
    func purchaseProduct(_ product: SKProduct) {
        startObservingPaymentQueue()
        buy(product) { [weak self] transaction in
            guard let self = self,
                  let transaction = transaction else {
                return
            }
            
            // If the purchase was successful and it was for the premium recipes identifiers
            // then publish the unlock change
            if transaction.payment.productIdentifier == ExtendedModel.unlockAllRecipesIdentifier,
               transaction.transactionState == .purchased {
                self.allRecipesUnlocked = true
            }
        }
    }
}

// MARK: - Private Logic

extension ExtendedModel {
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        // Save our completion handler for later
        purchaseCompletionHandler = completion
        
        // Create the payment and add it to the queue
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    private func hasPurchasedIAP(_ identifier: String) -> Bool {
        completedPurchases.contains(identifier)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequest == nil else {
            return
        }
        // Store our completion handler for later
        fetchCompletionHandler = completion
        
        // Create and start this product request
        productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - SKPAymentTransactionObserver

extension ExtendedModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .purchasing, .deferred:
                break
            @unknown default:
                break
            }
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]) {
        completedPurchases.removeAll(where: { productIdentifiers.contains($0) })
        DispatchQueue.main.async {
            if productIdentifiers.contains(ExtendedModel.unlockAllRecipesIdentifier) {
                self.allRecipesUnlocked = false
            }
        }
    }
}

// MARK: - SKProductsRequestDelegate

extension ExtendedModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            var errorMessage = "Could not find any products."
            if !invalidProducts.isEmpty {
                errorMessage = "Invalid products: \(invalidProducts.joined(separator: ", "))"
            }
            print("\(errorMessage)")
            productsRequest = nil
            return
        }
        
        // Cache these for later use
        fetchedProducts = loadedProducts
    
        // Notify anyone waiting on the product load
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            
            // Clean up
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}
