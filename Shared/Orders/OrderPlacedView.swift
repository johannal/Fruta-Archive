//
//  OrderPlacedView.swift
//  Fruta
//

import SwiftUI
import StoreKit

struct OrderPlacedView: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject private var model: FrutaModel
    
    var orderReady: Bool {
        guard let order = model.order else { return false }
        return order.isReady
    }
    
    var blurView: some View {
        #if os(iOS)
        return VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
        #else
        return VisualEffectBlur()
        #endif
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                if orderReady, let order = model.order {
                    Card(title: "Your smoothie is ready!".uppercased(), subtitle: "Your \(order.smoothie.title) smoothie is ready to be picked up.")
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    Card(title: "Thank you for your order!".uppercased(), subtitle: "We will notify you when your order is ready.")
                }
            }
            .rotation3DEffect(.degrees(orderReady ? -180 : 0), axis: (x: 0, y: 1, z: 0), perspective: 1)
            .animation(.spring(response: 0.35, dampingFraction: 1), value: orderReady)
            
            Spacer()
            
            if !model.hasAccount {
                VStack {
                    Text("Sign up to get rewards!")
                        .font(Font.headline.bold())
                    
                    SignInWithAppleButton(.signUp) { _ in
                    } onCompletion: { _ in
                        model.createAccount()
                    }
                    .frame(minWidth: 100, maxWidth: 400)
                    .frame(height: 45)
                    .padding(.horizontal, 20)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    blurView
                        .opacity(orderReady ? 1 : 0)
                        .padding(.bottom, -100)
                        .edgesIgnoringSafeArea(.all)
                )
            }
            
            #if os(macOS)
            VStack(spacing: 0) {
                Divider()
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Text("OK")
                            .padding(.horizontal)
                            .contentShape(Rectangle())
                    }
                }
                .padding()
            }
            .background(Rectangle().fill(BackgroundStyle()))
            #endif
        }
        .background(
            ZStack(alignment: .center) {
                if let order = model.order {
                    order.smoothie.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color("order-placed-background")
                }
                
                blurView
                    .opacity(model.order!.isReady ? 0 : 1)
            }
            .edgesIgnoringSafeArea(.all)
        )
        .animation(.spring(response: 0.25, dampingFraction: 1), value: orderReady)
        .animation(.spring(response: 0.25, dampingFraction: 1), value: model.hasAccount)
        .onAppear {
            print("appearing...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.model.order?.isReady = true
            }
        }
    }
    
    struct Card: View {
        var title: String
        var subtitle: String
        
        var body: some View {
            Circle()
                .fill(BackgroundStyle())
                .overlay(
                    VStack(spacing: 16) {
                        Text(title)
                            .font(Font.title.bold())
                            .layoutPriority(1)
                        Text(subtitle)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
                .frame(width: 300, height: 300)
        }
    }
}

struct OrderPlacedView_Previews: PreviewProvider {
    static let orderReady: FrutaModel = {
        let dataStore = FrutaModel()
        dataStore.orderSmoothie(id: Smoothie.berryBlue.id)
        dataStore.order?.isReady = true
        return dataStore
    }()
    static let orderNotReady: FrutaModel = {
        let dataStore = FrutaModel()
        dataStore.orderSmoothie(id: Smoothie.berryBlue.id)
        return dataStore
    }()
    static var previews: some View {
        Group {
            OrderPlacedView(isPresented: .constant(true))
                .environmentObject(orderNotReady)
            
            OrderPlacedView(isPresented: .constant(true))
                .environmentObject(orderReady)
        }
    }
}
