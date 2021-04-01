//
//  IngredientView.swift
//  Fruta
//

import SwiftUI
import NutritionFacts
import UtilityViews

// MARK: - Ingredient View

struct IngredientView: View {
    var ingredient: Ingredient
    var displayAsCard: Bool
    var closeAction: () -> Void

    @State var visibleSide: Side = .front
    
    var body: some View {
        FlipView(visibleSide: visibleSide) {
            cardContent(frontSide)
        } back: {
            cardContent(backSide)
        }
        .frame(minWidth: 130, maxWidth: 480, maxHeight: 600)
        .contentShape(Rectangle())
        .animation(.flipCard, value: visibleSide)
    }

    @ViewBuilder var frontSide: some View {
        backgroundImage

        Text(ingredient.name.uppercased())
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .lineLimit(1)
            .foregroundColor(ingredient.title.color)
            .rotationEffect(displayAsCard ? ingredient.title.rotation: .degrees(0))
            .opacity(ingredient.title.opacity)
            .blendMode(ingredient.title.blendMode)
            .font(Font.system(size: displayAsCard ? ingredient.title.fontSize : 40, weight: .bold))
            .minimumScaleFactor(0.25)
            .offset(displayAsCard ? ingredient.title.offset : .zero)
            
        cardControls(for: .front)
            .foregroundColor(ingredient.title.color)
            .opacity(ingredient.title.opacity)
            .blendMode(ingredient.title.blendMode)
    }

    @ViewBuilder var backSide: some View {
        backgroundImage
            .scaleEffect(x: -1)
        
        #if os(iOS)
        VisualEffectBlur(blurStyle: .systemThinMaterial, vibrancyStyle: .fill) {
            if let nutritionFact = ingredient.nutritionFact {
                NutritionFactView(nutritionFact: nutritionFact)
            }
            cardControls(for: .back)
        }
        #else
        VisualEffectBlur()
        if let nutritionFact = ingredient.nutritionFact {
            NutritionFactView(nutritionFact: nutritionFact)
        }
        cardControls(for: .back)
        #endif
    }
    
    var backgroundImage: some View {
        GeometryReader { geo in
            ingredient.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(displayAsCard ? ingredient.cardCrop.scale : ingredient.thumbnailCrop.scale)
                .offset(displayAsCard ? ingredient.cardCrop.offset : ingredient.thumbnailCrop.offset)
                .frame(width: geo.size.width, height: geo.size.height)
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder func cardControls(for side: Side) -> some View {
        if displayAsCard {
            VStack {
                if side == .front {
                    CardActionButton(systemImage: "xmark.circle.fill", action: closeAction)
                }
                Spacer()
                CardActionButton(systemImage: side == .front ? "info.circle.fill" : "arrow.left.circle.fill", action: { visibleSide.toggle() })
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
    func cardContent<Content: View>(_ content: Content) -> some View {
        ZStack {
            content
        }
        .clipShape(shape)
        .overlay(
            shape
                .inset(by: 0.5)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Previews

struct IngredientView_Previews: PreviewProvider {
    static let ingredient = Ingredient.orange
    static var previews: some View {
        Group {
            IngredientView(ingredient: ingredient, displayAsCard: false, closeAction: {})
                .frame(width: 180, height: 180)
                .previewDisplayName("Grid Cell")
            
            IngredientView(ingredient: ingredient, displayAsCard: true, closeAction: {})
                .frame(width: 300, height: 450)
                .previewDisplayName("Card")

            IngredientView(ingredient: ingredient, displayAsCard: true, closeAction: {}, visibleSide: .back)
                .frame(width: 300, height: 450)
                .previewDisplayName("Nutrition Facts")
        }
        .previewLayout(.sizeThatFits)
    }
}
