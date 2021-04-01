//
//  RecipeList
//  Fruta
//

import SwiftUI

struct RecipeList: View {
    @EnvironmentObject private var model: FrutaModel
    
    var smoothies: [Smoothie] {
        if model.allRecipesUnlocked {
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
            if !model.allRecipesUnlocked {
                if let product = model.unlockAllRecipesProduct {
                    RecipeUnlockButton(product: .init(for: product), purchaseAction: { model.purchaseProduct(product) })
                } else {
                    RecipeUnlockButton(product: .init(title: "Unlock All Recipes",
                                description: "Loading...", availability: .unavailable), purchaseAction: {})
                }
            }
        }
        .scaleEffect(model.allRecipesUnlocked ? 0.8 : 1)
        .offset(y: model.allRecipesUnlocked ? cardOffscreenOffset : 0)
        .clipped()
    }
    
    var body: some View {
        List {
            #if os(iOS)
            unlockButton.listRowInsets(EdgeInsets())
            #endif
            ForEach(smoothies) { smoothie in
                NavigationLink(destination: RecipeView(smoothie: smoothie)) {
                    SmoothieRow(smoothie: smoothie)
                }
            }
        }
        .overlay(Group {
            #if os(macOS)
            unlockButton
            #endif
        }, alignment: .bottom)
        .navigationTitle("Recipes")
        .animation(.spring(response: 1, dampingFraction: 1), value: model.allRecipesUnlocked)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static let unlocked: FrutaModel = {
        let store = FrutaModel()
        store.allRecipesUnlocked = true
        return store
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
