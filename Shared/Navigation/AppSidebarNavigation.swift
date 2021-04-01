//
//  AppSidebarNavigation.swift
//  Fruta
//

import SwiftUI

struct AppSidebarNavigation: View {
    var sidebar: some View {
        List {
            NavigationLink(destination: SmoothieMenu()) {
                Label("Menu", systemImage: "list.bullet")
            }
            
            NavigationLink(destination: FavoriteSmoothies()) {
                Label("Favorites", systemImage: "heart")
            }
            
            NavigationLink(destination: RewardsView()) {
                Label("Rewards", systemImage: "seal")
            }
        
            NavigationLink(destination: RecipeList()) {
                Label("Recipes", systemImage: "book.closed")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Smoothies")
    }
    
    var body: some View {
        NavigationView {
            #if os(macOS)
            sidebar.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
            #else
            sidebar
            #endif
            
            Text("Content List")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            #if os(macOS)
            Text("Select a Smoothie")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar { Spacer() }
            #else
            Text("Select a Smoothie")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            #endif
        }
    }
    
    struct Placeholder: View {
        var title: String
        
        var body: some View {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(title)
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
    }
}
