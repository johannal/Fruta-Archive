//
//  Ingredient+NutritionFacts.swift
//  Fruta
//

import Foundation
import NutritionFacts

extension Ingredient {
    var nutritionFact: NutritionFact? {
        NutritionFact.lookupFoodItem(id, forVolume: .cups(1))
    }
}
