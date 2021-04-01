//
//  Store.swift
//  Fruta
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

protocol StoreRevocationDelegate: class {
    func productIDsRevoked(productIDs: [String])
}

class Store: NSObject {
    static let unlockAllRecipesIdentifier = "com.example.apple-samplecode.fruta.unlock-recipes"
    
    private let allProductIdentifiers = Set([Store.unlockAllRecipesIdentifier])
    
    private var completedPurchases = [String]()
    private var fetchedProducts = [SKProduct]()
    private var productsRequest: SKProductsRequest?
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    weak var revocationDelegate: StoreRevocationDelegate?
    
    override init() {
        super.init()
        // Demo snippet: startObservingPaymentQueue() should be called here instead of in FrutaModel.swift
    }
    
    func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        // Save our completion handler for later
        purchaseCompletionHandler = completion
        
        // Create the payment and add it to the queue
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func hasPurchasedIAP(_ identifier: String) -> Bool {
        return completedPurchases.contains(identifier)
    }
    
    func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
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
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier })
    }
    
    func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
}

extension Store: SKPaymentTransactionObserver {
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
        if let revocationDelegate = revocationDelegate {
            DispatchQueue.main.async {
                revocationDelegate.productIDsRevoked(productIDs: productIdentifiers)
            }
        }
    }
}


extension Store: SKProductsRequestDelegate {
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
