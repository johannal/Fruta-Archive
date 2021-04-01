import XCTest

class ScrollingTests: XCTestCase {

    let app = XCUIApplication()

    func testSlowScrolling() throws {
        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: .default) {
            scrollSmoothieListWithVelocity(velocity: .slow)
        }
    }

    func testFastScrolling() throws {
        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: .default) {
            scrollSmoothieListWithVelocity(velocity: .fast)
        }
    }

    private func scrollSmoothieListWithVelocity(velocity: XCUIGestureVelocity) {
        app.launch()
        app.tabBars.buttons["Menu"].tap()

        let smoothieList = app.tables.firstMatch
        XCTAssert(smoothieList.exists, "Expected to find a list of smoothies")

        smoothieList.swipeUp(velocity: velocity)
    }

}
