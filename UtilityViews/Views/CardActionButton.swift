//
//  CardActionButton.swift
//  UtilityViews
//

import SwiftUI

public struct CardActionButton: View {
    public var systemImage: String
    public var action: () -> Void

    public init(systemImage: String, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(Font.title.bold())
                .imageScale(.large)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
    }
}

struct CardActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CardActionButton(systemImage: "xmark", action: {})
            .previewLayout(.sizeThatFits)
    }
}
