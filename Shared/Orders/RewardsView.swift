//
//  RewardsView.swift
//  Fruta
//

import SwiftUI
import UtilityViews

struct RewardsView: View {
    @EnvironmentObject private var model: FrutaModel
    
    var numberOfStamps: Int {
        guard let account = model.account else { return 0 }
        return min(max(account.pointsEarned - account.pointsSpent, 0), 10)
    }
    
    var columns: [GridItem] = .init(repeating: GridItem(.flexible(minimum: 44), spacing: 16), count: 5)
    
    var blurView: some View {
        #if os(iOS)
        return VisualEffectBlur(blurStyle: .systemThinMaterial)
        #else
        return VisualEffectBlur()
        #endif
    }
    
    var content: some View {
        ZStack {
            BubbleView(opacity: 0.1, size: 300, x: 350, y: -10)
            BubbleView(opacity: 0.05, size: 350, x: 0, y: 700)
            BubbleView(opacity: 0.15, size: 35, x: 180, y: 100)
            BubbleView(opacity: 0.1, size: 12, x: 102, y: 50)
            BubbleView(opacity: 0.1, size: 10, x: 180, y: 5)
            BubbleView(opacity: 0.05, size: 32, x: 300, y: 180)
            BubbleView(opacity: 0.1, size: 12, x: 200, y: 600)
            BubbleView(opacity: 0.05, size: 8, x: 250, y: 700)
            BubbleView(opacity: 0.12, size: 35, x: 300, y: 680)

            VStack {
                Spacer()
                VStack {
                    VStack {
                        Text("Rewards Card")
                            .font(Font.title2.bold())
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(1...10, id: \.self) { index in
                                stampSlot(for: index, account: model.account ?? Account())
                            }
                        }
                        .frame(maxWidth: 300)
                        .padding(8)
                    }
                    .padding()
                    .background(Rectangle().fill(BackgroundStyle()))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    
                    Text(numberOfStamps < 10 ? "You are \(10 - numberOfStamps) points away from a free smoothie!" : "Congratulations, you got yourself a free smoothie!")
                        .font(Font.system(.headline, design: .rounded).bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("rewards-foreground"))
                        .padding(.horizontal, 50)
                }
                .padding(.horizontal)
                .opacity(model.hasAccount ? 1 : 0.5)
                .onDisappear {
                    model.account?.unstampedPoints = 0
                }
                Spacer()
                if !model.hasAccount {
                    VStack {
                        Text("Sign up to get rewards!")
                            .font(Font.system(.headline, design: .rounded).bold())

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
                            .padding(.bottom, -100)
                            .edgesIgnoringSafeArea(.all)
                    )
            }
        }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("rewards-background").edgesIgnoringSafeArea(.all))
        .navigationTitle("Rewards")
    }
    
    @ViewBuilder var body: some View {
        #if os(iOS)
        content.navigationBarHidden(true)
        #else
        content
        #endif
    }
    
    func stampSlot(for index: Int, account: Account) -> StampSlot {
        let status: StampSlot.Status
        if index <= numberOfStamps {
            if index > numberOfStamps - account.unstampedPoints {
                let delayIndex = index - (numberOfStamps - account.unstampedPoints)
                status = .newlyStamped(delay: Double(delayIndex) * 0.15)
            } else {
                status = .stamped
            }
        } else {
            status = .unstamped
        }
        return StampSlot(status: status)
    }
    
    struct StampSlot: View {
        enum Status {
            case unstamped
            case newlyStamped(delay: Double)
            case stamped
        }
        
        var status: Status
        
        @State private var appear = false
        
        var animation: Animation {
            switch status {
            case .newlyStamped(let delay):
                return Animation.spring(response: 0.5, dampingFraction: 0.8).delay(delay)
            default:
                return Animation.linear(duration: 0)
            }
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color("rewards-background").opacity(0.3))
                
                switch status {
                case .stamped, .newlyStamped:
                    Image(systemName: "seal.fill")
                        .resizable()
                        .padding(8)
                        .scaleEffect(appear ? 1 : 2)
                        .opacity(appear ? 1 : 0)
                        .foregroundColor(Color("rewards-foreground"))
                        .animation(animation, value: appear)
                default:
                    EmptyView()
                }
            }
            .frame(width: 44, height: 44)
            .onAppear {
                appear = true
            }
            .onDisappear {
                appear = false
            }
        }
    }
}

struct SmoothieRewards_Previews: PreviewProvider {
    static let dataStore: FrutaModel = {
        var dataStore = FrutaModel()
        dataStore.createAccount()
        dataStore.orderSmoothie(id: Smoothie.thatsBerryBananas.id)
        dataStore.orderSmoothie(id: Smoothie.thatsBerryBananas.id)
        return dataStore
    }()
    
    static var previews: some View {
        Group {
            RewardsView()
                .preferredColorScheme(.light)
            RewardsView()
                .preferredColorScheme(.dark)
            RewardsView()
                .environmentObject(FrutaModel())
        }
        .environmentObject(dataStore)
    }
}
