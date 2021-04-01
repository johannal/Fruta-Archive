import XCTest
@testable import Fruta

class SmoothieNetworkingTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        // Demo snippet: try XCTSkipUnless(Smoothie.serverIsAvailable, "Smoothie server is unavailable")
    }

    func testFetchingSmoothiesFromServer() throws {
        let smoothies = try Smoothie.fetchSynchronouslyFromServer()
        XCTAssertGreaterThan(smoothies.count, 0, "The server returned no smoothies")
    }

    func testUpdateSmoothieOnServer() throws {
        let smoothie = SmoothieFactory.blendSmoothie()
        try smoothie.updateOnServer()
    }

    func testDeleteSmoothieFromServer() throws {
        let smoothie = SmoothieFactory.blendSmoothie()
        try smoothie.deleteFromServer()
    }

    func testPostSmoothieToServer() throws {
        let smoothie = SmoothieFactory.blendSmoothie()
        try smoothie.postToServer()
    }
}
