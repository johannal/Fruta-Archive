//
//  SmoothieHeaderView.swift
//  Fruta
//

import SwiftUI
import NutritionFacts

struct SmoothieHeaderView: View {
    var smoothie: Smoothie
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var horizontallyConstrained: Bool {
        #if os(iOS)
        return horizontalSizeClass == .compact
        #else
        return false
        #endif
    }
    
    var backgroundColor: Color {
        #if os(macOS)
        return Color(.textBackgroundColor)
        #else
        return Color(.secondarySystemBackground)
        #endif
    }
    
    @ViewBuilder var body: some View {
        if horizontallyConstrained {
            fullBleedContent
        } else {
            wideContent
        }
    }
    
    var fullBleedContent: some View {
        VStack(spacing: 0) {
            smoothie.image
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack(alignment: .leading) {
                Text(smoothie.description)
                Text("\(smoothie.kilocalories) Calories")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
    
    var wideClipShape = RoundedRectangle(cornerRadius: 20, style: .continuous)
    var wideContent: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                #if os(macOS)
                Text(smoothie.title)
                    .font(Font.largeTitle.bold())
                #endif
                Text(smoothie.description)
                    .font(.title2)
                Spacer()
                Text("\(smoothie.kilocalories) Calories")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(backgroundColor)
            
            smoothie.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 220, height: 250)
                .clipped()
        }
        .frame(height: 250)
        .clipShape(wideClipShape)
        .overlay(
            wideClipShape
                .inset(by: 0.5)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .padding()
    }
}

struct SmoothieHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieHeaderView(smoothie: .berryBlue)
    }
}
