//
//  RecipeUnlockButton.swift
//  Fruta
//

import SwiftUI
import StoreKit
import UtilityViews

struct RecipeUnlockButton: View {
    var product: Product
    var purchaseAction: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ViewBuilder var purchaseButton: some View {
        if case let .available(price, locale) = product.availability {
            let displayPrice: String = {
                let formatter = NumberFormatter()
                formatter.locale = locale
                formatter.numberStyle = .currency
                return formatter.string(for: price)!
            }()
            Button(action: purchaseAction) {
                Text(displayPrice)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(colorScheme == .light ? Color.white : .black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(minWidth: 80)
                    .background(colorScheme == .light ? Color.black : .white)
                    .clipShape(Capsule())
                    .contentShape(Rectangle())
            }
            .buttonStyle(SquishableButtonStyle())
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("smoothie/recipes-background").resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 225)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.headline)
                        .bold()
                    Text(product.description)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Spacer()
                
                purchaseButton
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(VisualEffectBlur())
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Product
extension RecipeUnlockButton {
    struct Product {
        var title: String
        var description: String
        var availability: Availability
        
        enum Availability {
            case available(price: NSDecimalNumber, locale: Locale)
            case unavailable
        }
    }
}

extension RecipeUnlockButton.Product {
    init(for product: SKProduct) {
        title = product.localizedTitle
        description = product.localizedDescription
        availability = .available(price: product.price, locale: product.priceLocale)
    }
}

// MARK: - Previews
struct RecipeUnlockButton_Previews: PreviewProvider {
    static let availableProduct = RecipeUnlockButton.Product(
        title: "Unlock All Recipes",
        description: "Make smoothies at home!",
        availability: .available(price: 4.99, locale: .current)
    )
    
    static let unavailableProduct = RecipeUnlockButton.Product(
        title: "Unlock All Recipes",
        description: "Loading...",
        availability: .unavailable
    )
    
    static var previews: some View {
        Group {
            RecipeUnlockButton(product: availableProduct, purchaseAction: {})
            RecipeUnlockButton(product: unavailableProduct, purchaseAction: {})
        }
        .previewLayout(.sizeThatFits)
    }
}
