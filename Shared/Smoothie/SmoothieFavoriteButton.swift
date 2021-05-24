//
//  SmoothieFavoriteButton
//  Fruta
//

import SwiftUI

struct SmoothieFavoriteButton: View {
    @EnvironmentObject private var model: Model
    
    var smoothie: Smoothie?
    
    var isFavorite: Bool {
        guard let smoothie = smoothie else { return false }
        return model.favoriteSmoothieIDs.contains(smoothie.id)
    }
    
    var body: some View {
        Button(action: toggleFavorite) {
            if isFavorite {
                Label { // swiftlint:disable:this no_space_in_method_call
                    Text("Remove from Favorites", comment: "Toolbar button/menu item to remove a smoothie from favorites")
                } icon: {
                    Image(systemName: "heart.fill")
                }
            } else {
                Label { // swiftlint:disable:this no_space_in_method_call
                    Text("Add to Favorites", comment: "Toolbar button/menu item to add a smoothie to favorites")
                } icon: {
                    Image(systemName: "heart")
                }

            }
        }
    }
    
    func toggleFavorite() {
        guard let smoothie = smoothie else { return }
        model.toggleFavorite(smoothie: smoothie)
    }
}

struct SmoothieFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieFavoriteButton(smoothie: .berryBlue)
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(Model())
    }
}
