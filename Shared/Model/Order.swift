//
//  Order.swift
//  Fruta
//

import Foundation

struct Order {
    var smoothieID: Smoothie.ID
    var points: Int
    var isReady: Bool
    
    var smoothie: Smoothie {
        Smoothie(for: smoothieID)!
    }
}
