//
// ExtendedModel
// FrutaExpanded
//

import Combine
import AuthenticationServices
import StoreKit

typealias FrutaModel = ExtendedModel

class ExtendedModel: Model {
    @Published var order: Order?
    @Published var account: Account?
    
    var hasAccount: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return userCredential != nil && account != nil
        #endif
    }
    
    @Published var favoriteSmoothieIDs = Set<Smoothie.ID>()
    
    @Published var isApplePayEnabled = true
    @Published var allRecipesUnlocked = false
    
    let defaults = UserDefaults(suiteName: "group.example.fruta-extended")
    
    private var userCredential: String? {
        get { defaults?.string(forKey: "UserCredential") }
        set { defaults?.setValue(newValue, forKey: "UserCredential") }
    }
    
    init() {
        guard let user = userCredential else { return }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: user) { state, error in
            if state == .authorized || state == .transferred {
                DispatchQueue.main.async {
                    self.createAccount()
                }
            }
        }
    }
    
    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result, let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            if case .failure(let error) = result {
                print("Authentication error: \(error.localizedDescription)")
            }
            return
        }
        DispatchQueue.main.async {
            self.userCredential = credential.user
            self.createAccount()
        }
    }
}
