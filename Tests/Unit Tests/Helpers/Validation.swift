import XCTest
@testable import Fruta

extension Smoothie {

    static func validateSmoothieMandatoryData(smoothies: [Smoothie]) throws {
        for smoothie in smoothies {
            XCTAssertFalse(smoothie.title.isEmpty, "Expected non-empty smoothie title")
            XCTAssertFalse(smoothie.description.isEmpty, "Expected non-empty smoothie description")
            XCTAssertTrue(smoothie.measuredIngredients.count > 0, "Expected at least one ingredient")
        }
    }

}
