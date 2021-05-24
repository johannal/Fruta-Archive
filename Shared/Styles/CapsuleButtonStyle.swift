//
//  CapsuleButtonStyle
//  Fruta
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .dynamicTypeSize(.large)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(in: Capsule())
            .foregroundStyle(Color.accentColor)
            .contentShape(Capsule())
            #if os(iOS)
            .hoverEffect(.lift)
            #endif
    }
}

extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: CapsuleButtonStyle {
        CapsuleButtonStyle()
    }
}
