//
//  AppTabNavigation.swift
//  Fruta iOS
//

import SwiftUI

struct AppTabNavigation: View {

    enum Tab {
        case menu
        case favorites
        case rewards
        case recipes
    }

    @State private var selection: Tab = .menu

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                SmoothieMenu()
            }
            .tabItem {
                Label("Menu", systemImage: "list.bullet")
                    .accessibility(label: Text("Menu"))
            }
            .tag(Tab.menu)
            
            NavigationView {
                FavoriteSmoothies()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(Tab.favorites)
            
            NavigationView {
                RewardsView()
            }
            .tabItem {
                Label("Rewards", systemImage: "seal.fill")
            }
            .tag(Tab.rewards)
            
            NavigationView {
                RecipeList()
            }
            .tabItem {
                Label("Recipes", systemImage: "book.closed.fill")
            }
            .tag(Tab.recipes)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
