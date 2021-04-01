import XCTest

class ProtectedResourceTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLowCalorieOfferings() throws {

        app.resetAuthorizationStatus(for: .health)

        app.launchArguments = ["-enable-healthkit"]
        app.launch()
        
        let healthWindow = getHealthWindow()
        XCTAssertTrue(healthWindow.waitForExistence(timeout: 30), "Expected to find a Health authorization window")

        let activeEnergySwitch = healthWindow.switches["Active Energy"]
        activeEnergySwitch.tap()
        healthWindow.buttons["Allow"].tap()

    }
    
    func testPopularNearMe() throws {
        
        app.resetAuthorizationStatus(for: .location)
        app.launch()
        
        let locationAuthorizationAlert = getSystemAlert()
        XCTAssertTrue(locationAuthorizationAlert.exists, "Expected to find a Location authorization alert")

        let allowAccessButton = locationAuthorizationAlert.buttons["Allow While Using App"]
        allowAccessButton.tap()
        
        app.tabBars.buttons["Menu"].tap()
        
        XCTAssert(app.staticTexts["Popular Near You"].exists)

    }
    
}
