import XCTest
@testable import Fruta

extension Smoothie {
    static var serverIsAvailable: Bool { false }

    static func performGETRequest() throws -> Data {
        let smoothie = SmoothieFactory.blendSmoothie()
        return try JSONEncoder().encode([smoothie])
    }
}

@objc(TestObserver) class TestObserver : NSObject, XCTestObservation {
    static var currentTestCase: XCTestCase?

    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }

    func testCaseWillStart(_ testCase: XCTestCase) {
        TestObserver.currentTestCase = testCase
    }
}
