//
//  Account.swift
//  Fruta
//

import Foundation

struct Account {
    var orderHistory = [Order]()
    var pointsEarned: Int {
        orderHistory.map({ $0.points }).reduce(0, +)
    }
    var pointsSpent = 0
    var unstampedPoints = 0
}
