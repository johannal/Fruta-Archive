//
//  SmoothieList.swift
//  Fruta
//

import SwiftUI

struct SmoothieList: View {
    var smoothies: [Smoothie]
    
    @EnvironmentObject private var model: FrutaModel
    
    var content: some View {
        List(smoothies) { smoothie in
            NavigationLink(destination: SmoothieView(smoothie: smoothie).environmentObject(model)) {
                SmoothieRowView(smoothie: smoothie)
            }
        }
    }
    
    @ViewBuilder var body: some View {
        #if os(iOS)
        content
        #else
        content
            .frame(minWidth: 100, idealWidth: 200, maxWidth: 300, maxHeight: .infinity)
        #endif
    }
}

struct SmoothieList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                SmoothieList(smoothies: Smoothie.all)
                    .navigationTitle("Smoothies")
                    .environmentObject(FrutaModel())
            }
            .preferredColorScheme(scheme)
        }
    }
}
