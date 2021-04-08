//
//  SmoothieMenu
//  Fruta
//

import SwiftUI

struct SmoothieMenu: View {
    
    var body: some View {
        SmoothieList(smoothies: Smoothie.all())
            .navigationTitle("Menu")
    }
    
}

struct SmoothieMenu_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieMenu()
            .environmentObject(FrutaModel())
    }
}
