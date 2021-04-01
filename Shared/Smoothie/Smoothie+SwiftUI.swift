//
//  Smoothie+SwiftUI
//  Fruta
//

import SwiftUI

// MARK: - SwiftUI.Image
extension Smoothie {
    var image: Image {
        Image("smoothie/\(id)", label: Text(title))
            .renderingMode(.original)
    }
}
