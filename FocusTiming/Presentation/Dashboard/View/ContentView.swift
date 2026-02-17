//
//  ContentView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        
        Group {
            if authManager.isSignedIn {
                RootTabView(userName: authManager.userName)
            } else {
                loginView
            }
        }
    }
}

private extension ContentView {
    
    var loginView: some View {
        VStack(spacing: 40) {
            
            Text("FocusTime")
                .font(.largeTitle.bold())
            
            GoogleSignInButton {
                authManager.signIn()
            }
            .frame(width: 220, height: 50)
        }
    }
}
