//
//  CountButton.swift
//  UtilityViews
//

import SwiftUI

public struct CountButton: View {

    public enum Mode {
        case increment
        case decrement
    }

    public let mode: CountButton.Mode
    public let action: () -> Void

    public init(mode: CountButton.Mode, action: @escaping () -> Void) {
        self.mode = mode
        self.action = action
    }

    @Environment(\.isEnabled) var isEnabled

    @ViewBuilder var image: some View {
        switch mode {
        case .increment:
            Image(systemName: isEnabled ? "plus.circle.fill" : "plus.circle")
        case .decrement:
            Image(systemName: isEnabled ? "minus.circle.fill" : "minus.circle")
        }
    }

    public var body: some View {
        Button(action: action) {
            image
                .imageScale(.large)
                .padding()
                .contentShape(Rectangle())
                .opacity(0.5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CountButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountButton(mode: .increment, action: {})
            CountButton(mode: .decrement, action: {})
            CountButton(mode: .increment, action: {}).disabled(true)
            CountButton(mode: .decrement, action: {}).disabled(true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
