import Foundation
import NutritionFacts

extension NutritionFact: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        description
    }
}
extension Measurement: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let mf = MeasurementFormatter()
        mf.unitOptions = .providedUnit
        mf.unitStyle = .long
        mf.numberFormatter.maximumFractionDigits = 0
        return mf.string(from: self)
    }
} 
