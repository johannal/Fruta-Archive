//
//  Ingredient+NutritionFacts
//  Fruta
//

extension Ingredient {
    var nutritionFact: NutritionFact? {
        NutritionFact.lookupFoodItem(id, forVolume: .cups(1))
    }
}
