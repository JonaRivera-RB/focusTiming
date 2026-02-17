//
//  AuthManager.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import Foundation
import GoogleSignIn
import UIKit

@MainActor
final class AuthManager: ObservableObject {
    
    // MARK: - Published State
    
    @Published private(set) var isSignedIn = false
    @Published private(set) var userName: String = ""
    
    // MARK: - Init
    
    init() {
        restoreSession()
    }
    
    // MARK: - Public API
    
    func signIn() {
        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first?
            .rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootVC,
            hint: nil,
            additionalScopes: ["https://www.googleapis.com/auth/calendar.readonly"]
        ) { [weak self] result, error in
            
            guard let self else { return }
            
            if let error = error {
                print("Login error:", error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            
            self.handleAuthenticatedUser(user)
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        AuthTokenManager.shared.delete()
        
        isSignedIn = false
        userName = ""
    }
    
    // MARK: - Private
    
    private func restoreSession() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, _ in
            
            guard let self,
                  let user else { return }
            
            self.handleAuthenticatedUser(user)
        }
    }
    
    private func handleAuthenticatedUser(_ user: GIDGoogleUser) {
        
        isSignedIn = true
        userName = user.profile?.givenName ?? user.profile?.email ?? ""
        
        let token = user.accessToken.tokenString
        AuthTokenManager.shared.save(token: token)
    }
}
