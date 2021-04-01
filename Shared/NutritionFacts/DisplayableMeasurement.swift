//
//  DisplayableMeasurement.swift
//  
//

import Foundation
import SwiftUI

public protocol DisplayableMeasurement {
    var unitImage: Image { get }
    func localizedSummary(unitStyle: MeasurementFormatter.UnitStyle, unitOptions: MeasurementFormatter.UnitOptions) -> String
}

extension DisplayableMeasurement {
    public func localizedSummary() -> String {
        localizedSummary(unitStyle: .long, unitOptions: [.providedUnit])
    }
}

extension Measurement: DisplayableMeasurement {
    public func localizedSummary(unitStyle: MeasurementFormatter.UnitStyle = .long, unitOptions: MeasurementFormatter.UnitOptions = [.providedUnit]) -> String {
        let mf = MeasurementFormatter()
        mf.unitStyle = unitStyle
        mf.unitOptions = unitOptions
        return mf.string(from: self)
    }

    public var unitImage: Image {
        unit.unitIcon
    }
}
