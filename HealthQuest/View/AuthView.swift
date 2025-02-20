//
//  SignInView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/2/24.
//

import SwiftUI

//Container View for Upon Sign-In
//If user has not logged in it sends them to AuthView() which is essentially the sign in page
struct AuthView: View {
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        Group{
            switch authController.authState {
            case .undefined:
                //undefined indicates user has not logged in yet
                //this will then take them to AuthView for them to log in, once they try signing in it will trigger the isLoading property of AuthController sending them to a ProgressView where they won't be able to call any more functions
                //during this time we be checking if the user exists or not, and if not it will intialize a database for them
                //There might be some weird behavior here as the views are controlled by both the authState and isLoading
                //this might lead to a case where it goes from the progressView Initializing... to the progressView Singing In... but that should be okay? since it indicates to the user that they have successfully signed in, while we are still setting up a new profile for them
                if !authController.isLoading{
                    SignInView()
                        .environmentObject(authController)
                }
                else {
                    ProgressView("Initalizing...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            case .authenticated:
                if !authController.isLoading{
                    LaunchView()
                        .environmentObject(authController)
                }
                else{
                    ProgressView("Signing In...")
                        .progressViewStyle(CircularProgressViewStyle())
                }

            case .notAuthenticated:
                SignInView()
                    .environmentObject(authController)
                    .disabled(authController.isLoading)
            }
        }
        .task{
            await authController.startListeningToAuthState()
        }

    }
}

#Preview {
    AuthView()
}
