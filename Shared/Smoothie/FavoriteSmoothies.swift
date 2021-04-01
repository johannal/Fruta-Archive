//
//  FavoriteSmoothies.swift
//  Fruta
//

import SwiftUI

struct FavoriteSmoothies: View {
    @EnvironmentObject private var model: FrutaModel
    
    var body: some View {
        Group {
            if model.favoriteSmoothieIDs.isEmpty {
                Text("Add some smoothies to your favorites!")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                SmoothieList(smoothies: Array(model.favoriteSmoothieIDs.map { Smoothie(for: $0)! }))
            }
        }
        .navigationTitle("Favorites")
    }
}

struct FavoriteSmoothies_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteSmoothies()
            .environmentObject(FrutaModel())
    }
}
