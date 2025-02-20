//
//  HealthQuestApp.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/1/24.
//

import SwiftUI


@main
struct HealthQuest: App {
    // register app delegate for Firebase setup
    // configure Firebase  before trying to use Google-Sign In
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authController = AuthController()
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(authController)
        }
    }
}

//HealthQuestApp -> SignInView -> LaunchView -> MainView -> PlantEditorView
//                      |           ^              |     \
//                      \/          |              \/     _|
//                  AuthView   ------       HealthView      SettingsView
