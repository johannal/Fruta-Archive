import XCTest
import StoreKitTest

@testable import Fruta

class InAppPurchaseTests: XCTestCase {
    private let store = Store()
    private var testSession: SKTestSession!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        testSession = try SKTestSession(configurationFileNamed: "Configuration")
        testSession.disableDialogs = true
    }
    
    // TODO(iburns):  Remove this function once the public seed has AzulSeed18A5301e
    override func tearDownWithError() throws {
        testSession.resetToDefaultState()
    }
    
    func testRecipeUnlock() throws {
        let iapProductID = "com.example.apple-samplecode.fruta.unlock-recipes"
        let success = buyIAP(withIdentifier: iapProductID)
        
        XCTAssertTrue(success, "In-app purchase failed")
        XCTAssertTrue(store.hasPurchasedIAP(iapProductID), "Purchased content is not available as expected")
    }
    
    func testUnpurchasedContent() {
        let iapProductID = "com.example.apple-samplecode.fruta.unlock-recipe.berry-blue"
        XCTAssertFalse(store.hasPurchasedIAP(iapProductID), "Unpurchased content should not be avialable")
    }
    
    // TODO(iburns):  Add an Ask to Buy test here once the public seed has AzulSeed18A5301e
    // func testAskToBuyConfirmation() {
    // }
        
    
    // MARK: - Private functions
    
    private func buyIAP(withIdentifier identifier: String) -> Bool {
        guard let product = fetchProduct(identifier) else {
            return false
        }
        
        return performPurchase(product)
    }
    
    private func fetchProduct(_ identifier: String) -> SKProduct? {
        var product: SKProduct?
        let fetchExpectation = expectation(description: "Fetch Products")
        store.fetchProducts { products in
            product = products.first(where: { $0.productIdentifier == identifier })
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(product)
        
        return product
    }
    
    private func performPurchase(_ product: SKProduct) -> Bool {
        var purchaseResult = false
        let purchaseExpectation = expectation(description: "Purchase \(product.productIdentifier)")
        store.buy(product) { transaction in
            purchaseResult = transaction?.transactionState == .purchased
            purchaseExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        return purchaseResult
    }
}
