import XCTest
@testable import Fruta

struct SmoothieFactory {
    static func blendSmoothie() -> Smoothie {
        Smoothie(id: "1", title: "Green Gains", description: "A healthy, low-calorie smoothie for protein lovers.", measuredIngredients: [])
    }
}
