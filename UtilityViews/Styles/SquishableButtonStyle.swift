//
//  SquishableButtonStyle.swift
//  UtilityViews
//

import SwiftUI

public struct SquishableButtonStyle: ButtonStyle {
    public let fadeOnPress: Bool

    public init(fadeOnPress: Bool = true) {
        self.fadeOnPress = fadeOnPress
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
