//
//  SettingsView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/4/24.
//

import SwiftUI

//currently only has signing out
//plan on adding functionality like settings difficulty, but current state of the project doesn't have a game loop so that will be implemented when needed
struct SettingsView: View {
    
    @EnvironmentObject private var authController: AuthController
    
    var body: some View {
        VStack {
            //upon clicking the big red button "Sign Out"... it signs you out
            //using a UIView called SignOutView, wrapped in UIViewRepresentable
            //to be able to use in the settings page.
            SignOutUIViewRepresentable {
                signOut()
                print("User signed out.")
            }
            .frame(height: 200) // Adjust the frame as needed
        }
        .padding()
    }
    
    
    
    func signOut(){
        do {
            try authController.signOut()
        } catch {
            print(error.localizedDescription)
        }
        do{
            authController.stopListeningtoAuthState()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthController())
}
