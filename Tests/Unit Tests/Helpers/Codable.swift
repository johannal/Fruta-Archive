import Foundation
@testable import Fruta

extension Smoothie {

    static func deserializeData(_ data: Data) throws -> [Smoothie] {
        let smoothies = try JSONDecoder().decode([Smoothie].self, from: data)

        try validateSmoothieMandatoryData(smoothies: smoothies)

        return smoothies
    }

}
