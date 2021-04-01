//
//  RecipeList.swift
//  Fruta
//

import SwiftUI

struct RecipeList: View {
    @EnvironmentObject private var model: FrutaModel
    
    var smoothies: [Smoothie] {
        if model.unlockedAllRecipes {
            return Smoothie.all
        } else {
            return Smoothie.all.filter { $0.hasFreeRecipe }
        }
    }
    
    var backgroundColor: Color {
        #if os(iOS)
        return Color(.secondarySystemFill)
        #else
        return Color(.windowBackgroundColor)
        #endif
    }
    
    var cardOffscreenOffset: CGFloat {
        #if os(iOS)
        return -300
        #else
        return 600
        #endif
    }
    
    var unlockButton: some View {
        Group {
            if !model.unlockedAllRecipes {
                if let product = model.unlockAllRecipesProduct {
                    RecipeUnlockButton(product: .init(for: product), purchaseAction: { model.purchaseProduct(product) })
                } else {
                    RecipeUnlockButton(product: .init(title: "Unlock All Recipes", description: "Loading...", availability: .unavailable), purchaseAction: {})
                }
            }
        }
        .padding()
        .scaleEffect(model.unlockedAllRecipes ? 0.8 : 1)
        .offset(y: model.unlockedAllRecipes ? cardOffscreenOffset : 0)
        .clipped()
        .listRowBackground(
            backgroundColor
                .opacity(model.unlockedAllRecipes ? 0 : 1)
                .edgesIgnoringSafeArea(.all)
        )
        .listRowInsets(EdgeInsets())
    }
    
    var body: some View {
        List {
            #if os(iOS)
            unlockButton
            #endif
            ForEach(smoothies) { smoothie in
                NavigationLink(destination: RecipeView(smoothie: smoothie)) {
                    SmoothieRowView(smoothie: smoothie, showNearbyPopularity: false)
                }
            }
        }
        .overlay(Group {
            #if os(macOS)
            unlockButton
            #endif
        }, alignment: .bottom)
        .navigationTitle("Recipes")
        .animation(.spring(response: 1, dampingFraction: 1), value: model.unlockedAllRecipes)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static let unlocked: FrutaModel = {
        let model = FrutaModel()
        model.unlockedAllRecipes = true
        return model
    }()
    static var previews: some View {
        Group {
            NavigationView {
                RecipeList()
            }
            .environmentObject(FrutaModel())
            .previewDisplayName("Locked")
            
            NavigationView {
                RecipeList()
            }
            .environmentObject(unlocked)
            .previewDisplayName("Unlocked")
        }
    }
}
