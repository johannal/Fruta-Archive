//
//  Smoothie+SwiftUI.swift
//  Fruta
//

import SwiftUI

// MARK: - SwiftUI.Image
extension Smoothie {
    var image: Image {
        Image("smoothie/\(id)").renderingMode(.original)
    }
}
