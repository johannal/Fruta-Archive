//
//  BubbleView.swift
//  UtilityViews
//

import SwiftUI

public struct BubbleView: View {
    public let opacity: Double
    public let size: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(opacity: Double, size: CGFloat, x: CGFloat, y: CGFloat) {
        self.opacity = opacity
        self.size = size
        self.x = x
        self.y = y
    }
    
    public var body: some View {
        Circle()
            .blendMode(.overlay)
            .opacity(opacity)
            .frame(width: size, height: size)
            .position(x: x, y: y)
    }
}
