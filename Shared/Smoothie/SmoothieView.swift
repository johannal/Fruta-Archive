//
//  SmoothieView.swift
//  Fruta
//

import SwiftUI
import NutritionFacts
import UtilityViews

struct SmoothieView: View {
    var smoothie: Smoothie
    
    @State private var presentingSheet = false
    @EnvironmentObject private var model: FrutaModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedIngredientID: Ingredient.ID?
    @Namespace private var namespace
    
    var isFavorite: Bool {
        model.favoriteSmoothieIDs.contains(smoothie.id)
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            PaymentButton(action: orderSmoothie)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    var favoriteButton: some View {
        let label = "\(isFavorite ? "Remove from" : "Add to") Favorites"
        let icon = isFavorite ? "heart.fill" : "heart"
        return Button(action: toggleFavorite) {
            #if os(iOS)
            Image(systemName: icon)
                .imageScale(.large)
                .contentShape(Rectangle())
            #else
            Label(label, systemImage: icon)
            #endif
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                content.padding(.bottom, 90)
            }
            .overlay(bottomBar, alignment: .bottom)

            ZStack {
                if selectedIngredientID != nil {
                    VisualEffectBlur()
                        .edgesIgnoringSafeArea(.all)
                }
                
                ForEach(smoothie.menuIngredients) { measuredIngredient in
                    IngredientView(ingredient: measuredIngredient.ingredient, displayAsCard: selectedIngredientID == measuredIngredient.id, closeAction: deselectIngredient)
                        .matchedGeometryEffect(id: measuredIngredient.id, in: namespace, isSource: selectedIngredientID == measuredIngredient.id)
                        .shadow(color: Color.black.opacity(selectedIngredientID == measuredIngredient.id ? 0.2 : 0), radius: 20, y: 10)
                        .padding(20)
                        .opacity(selectedIngredientID == measuredIngredient.id ? 1 : 0)
                        .zIndex(selectedIngredientID == measuredIngredient.id ? 1 : 0)
                }
            }
        }
        .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(smoothie.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                favoriteButton
            }
        }
        .sheet(isPresented: $presentingSheet) {
            NavigationView {
                OrderPlacedView(isPresented: $presentingSheet)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: { self.presentingSheet = false }) {
                                Text("Done")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
            }
            .environmentObject(model)
        }
    }
    
    var content: some View {
        VStack(spacing: 0) {
            SmoothieHeaderView(smoothie: smoothie)
                
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(Font.title).bold()
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .center)], alignment: .center, spacing: 16) {
                    ForEach(smoothie.menuIngredients) { measuredIngredient in
                        Button(action: {
                            withAnimation(.openCard) {
                                self.selectedIngredientID = measuredIngredient.id
                            }
                        }) {
                            IngredientView(
                                ingredient: measuredIngredient.ingredient,
                                displayAsCard: selectedIngredientID == measuredIngredient.id,
                                closeAction: deselectIngredient
                            )
                            .matchedGeometryEffect(
                                id: measuredIngredient.id,
                                in: namespace,
                                isSource: selectedIngredientID != measuredIngredient.id
                            )
                        }
                        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }
    
    func toggleFavorite() {
        if isFavorite {
            model.favoriteSmoothieIDs.remove(smoothie.id)
        } else {
            model.favoriteSmoothieIDs.insert(smoothie.id)
        }
    }
    
    func orderSmoothie() {
        model.orderSmoothie(id: smoothie.id)
        presentingSheet = true
    }
    
    func deselectIngredient() {
        withAnimation(.closeCard) {
            selectedIngredientID = nil
        }
    }
}

struct SmoothieView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SmoothieView(smoothie: .berryBlue)
            }
            
            ForEach([Smoothie.thatsBerryBananas, .oneInAMelon, .berryBlue]) { smoothie in
                SmoothieView(smoothie: smoothie)
                    .previewLayout(.sizeThatFits)
                    .frame(height: 700)
            }
        }
        .preferredColorScheme(.light)
        .environmentObject(FrutaModel())
    }
}
