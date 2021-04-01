import XCTest

class AppLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()
//        let menuTitle = app.staticTexts["Menu"]
//        let found = menuTitle.waitForExistence(timeout: 5)
//        XCTAssertTrue(found, "Expected to find Menu title within 5 seconds")
    }

}
