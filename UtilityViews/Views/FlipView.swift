//
//  FlipView.swift
//  UtilityViews
//

import SwiftUI

public enum Side {
    case front
    case back

    public mutating func toggle() {
        self = self == .front ? .back : .front
    }
}

public struct FlipView<Front : View, Back : View> : View {
    public var visibleSide: Side
    public var front: Front
    public var back: Back

    public init(visibleSide: Side = .front,
         @ViewBuilder front: () -> Front,
         @ViewBuilder back: () -> Back) {
        self.visibleSide = visibleSide
        self.front = front()
        self.back = back()
    }

    public var body: some View {
        ZStack {
            front
                .modifier(FlipModifier(side: .front, visibleSide: visibleSide))
            back
                .modifier(FlipModifier(side: .back, visibleSide: visibleSide))
        }
    }
}

public struct FlipModifier: AnimatableModifier {
    var side: Side
    var flipProgress: Double
    
    public init(side: Side, visibleSide: Side) {
        self.side = side
        self.flipProgress = visibleSide == .front ? 0 : 1
    }
    
    public var animatableData: Double {
        get { flipProgress }
        set { flipProgress = newValue }
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(x: scale, y: 1.0)
            .rotation3DEffect(.degrees(flipProgress * -180), axis: (x: 0.0, y: 1.0, z: 0.0), perspective: 0.5)
            .opacity(opacity)
    }

    var scale: CGFloat {
        switch side {
        case .front:
            return 1.0
        case .back:
            return -1.0
        }
    }

    var opacity: Double {
        switch side {
        case .front:
            return flipProgress <= 0.5 ? 1 : 0
        case .back:
            return flipProgress > 0.5 ? 1 : 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FlipView(visibleSide: .front) {
            Text("Front Side")
        } back: {
            Text("Back Side")
        }
    }
}
