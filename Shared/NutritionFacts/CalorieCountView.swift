//
//  CalorieCountView.swift
//

import SwiftUI
import DeveloperToolsSupport

public struct CalorieCountView: View {
    public var nutritionFact: NutritionFact

    public init(nutritionFact: NutritionFact) {
        self.nutritionFact = nutritionFact
    }

    private var lowCalories: Bool {
        // Consider lower than 200 kCal per 100g as low
        let caloriesPer100g = nutritionFact.converted(toMass: .grams(100)).kilocalories
        return caloriesPer100g < 100
    }

    private var kilocalories: Int {
        Int(nutritionFact.kilocalories)
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: lowCalories ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(lowCalories ? .green : .orange)
            Text("\(kilocalories) Calories")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Library Integration

public struct SmoothieRowView_LibraryContent: LibraryContentProvider {
    @LibraryContentBuilder public var views: [LibraryItem] {
        LibraryItem(
            CalorieCountView(nutritionFact: .banana),
            category: .control
        )
    }
}
