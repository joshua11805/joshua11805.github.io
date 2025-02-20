//
//  AuthView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/2/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct SignInView: View {
    
    @EnvironmentObject private var authController: AuthController
    
    
    var body: some View {

            ZStack{
                Color(.green)
                    .ignoresSafeArea(.all)
                VStack{
                    Text("Sign In")
                        .bold()
                        .font(.headline)
                    GoogleSignInButton(scheme: .light, style: .icon, state: .normal) {
                        signIn()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
    }
    
    @MainActor
    func signIn(){
        Task{
            do {
                try await authController.signIn()
            } catch {
                print(error.localizedDescription)
                print("Failed to log in")
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthController())
}
