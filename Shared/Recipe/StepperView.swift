//
//  StepperView.swift
//  Fruta
//

import SwiftUI
import UtilityViews

struct StepperView: View {
    @Binding var value: Int {
        didSet {
            tilt = value > oldValue ? 1 : -1
            withAnimation(.interactiveSpring(response: 1, dampingFraction: 1)) {
                tilt = 0
            }
        }
    }
    var label: String
    var configuration: Configuration
    
    @State private var tilt = 0.0

    struct Configuration {
        var increment: Int
        var minValue: Int
        var maxValue: Int
    }

    var body: some View {
        HStack {
            CountButton(mode: .decrement) {
                value = value - configuration.increment
            }
            .disabled(value <= configuration.minValue)

            Text(label)
                .frame(width: 150)
                .padding(.vertical)

            CountButton(mode: .increment) {
                value = value + configuration.increment
            }
            .disabled(configuration.maxValue <= value)
        }
        .font(Font.title2.bold())
        .foregroundColor(.primary)
        .background(VisualEffectBlur())
        .clipShape(Capsule())
        .rotation3DEffect(.degrees(3 * tilt), axis: (x: 0, y: 1, z: 0))
    }
}

struct StepperView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView(
            value: .constant(5),
            label: "Stepper",
            configuration: StepperView.Configuration(increment: 1, minValue: 1, maxValue: 10)
        )
        .padding()
    }
}
