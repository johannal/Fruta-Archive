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
                Label {
                    Text("Menu", comment: "Smoothie menu tab title")
                } icon: {
                    Image(systemName: "list.bullet")
                }
            }
            .tag(Tab.menu)
            
            NavigationView {
                FavoriteSmoothies()
            }
            .tabItem {
                Label {
                    Text("Favorites", comment: "Favorite smoothies tab title")
                } icon: {
                    Image(systemName: "heart.fill")
                }
            }
            .tag(Tab.favorites)
            
            NavigationView {
                RewardsView()
            }
            .tabItem {
                Label {
                    Text("Rewards", comment: "Smoothie rewards tab title")
                } icon: {
                    Image(systemName: "seal.fill")
                }
            }
            .tag(Tab.rewards)
            
            NavigationView {
                RecipeList()
            }
            .tabItem {
                Label {
                    Text("Recipes", comment: "Smoothie recipes tab title")
                } icon: {
                    Image(systemName: "book.closed.fill")
                }
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
