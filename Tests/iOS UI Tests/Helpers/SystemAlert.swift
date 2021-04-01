import Foundation
import XCTest

extension XCTestCase {
    func getSystemAlert() -> XCUIElement {
        return XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch
    }

    func getHealthWindow() -> XCUIElement {
        XCUIApplication().windows.containing(.staticText, identifier: "Health Access").firstMatch
    }
}
