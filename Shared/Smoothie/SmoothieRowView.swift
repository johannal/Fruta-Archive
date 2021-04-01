//
//  SmoothieRowView.swift
//  Fruta
//

import SwiftUI
import NutritionFacts

struct SmoothieRowView: View {
    var smoothie: Smoothie
    var showNearbyPopularity = true
    
    @EnvironmentObject private var model: FrutaModel

    var size: CGFloat {
        #if os(iOS)
        return 96
        #else
        return 60
        #endif
    }

    var cornerRadius: CGFloat {
        #if os(iOS)
        return 16
        #else
        return 8
        #endif
    }
    
    var verticalPadding: CGFloat {
        #if os(macOS)
        return 10
        #else
        return 0
        #endif
    }

    var displayIsPopularNearby: Bool {
        showNearbyPopularity && model.highlightPopularSmoothiesNearby && smoothie.isPopularNearby
    }
    
    var ingredients: String {
        ListFormatter.localizedString(byJoining: smoothie.menuIngredients.map { $0.ingredient.name })
    }

    var body: some View {
        HStack {
            smoothie.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            VStack(alignment: .leading) {
                Text(smoothie.title)
                    .font(.headline)
                
                if displayIsPopularNearby {
                    Text("Popular Near You")
                    .foregroundColor(.accentColor)
                }
                
                Text(ingredients)

                Text("\(smoothie.kilocalories) Calories")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .font(.subheadline)
        .padding(.vertical, verticalPadding)
    }
}

// MARK: - Previews

struct SmoothieRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SmoothieRowView(smoothie: Smoothie.lemonberry)
            SmoothieRowView(smoothie: Smoothie.thatsASmore)
        }
        .frame(width: 250, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
        .environmentObject(FrutaModel())
    }
}
