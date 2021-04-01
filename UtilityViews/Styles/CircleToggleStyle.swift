//
//  CircleToggleStyle.swift
//  UtilityViews
//

import SwiftUI

public struct CircleToggleStyle: ToggleStyle {

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        CircleToggle(configuration: configuration)
    }

    private struct CircleToggle : View {
        var configuration: Configuration

        var body: some View {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .imageScale(.large)
                .font(Font.title)
        }
    }
}
