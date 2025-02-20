//
//  GoogleButtonStyle.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/3/24.
//

//ignore this file I was gonna try to implement my own google Sign in button because the standard one is ugly
import SwiftUI
import GoogleSignInSwift

enum CustomSignInButtonColorScheme {
    case light
    case dark
    case red
    case blue

    // Map custom cases to the original GoogleSignInButtonColorScheme or define your logic
    var googleColorScheme: GoogleSignInButtonColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .red, .blue:
            return nil // These are custom and not directly mappable
        }
    }

    // Add UIColor or SwiftUI Color for custom cases
    var customColor: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        case .red:
            return .red
        case .blue:
            return .blue
        }
    }
}

extension CustomSignInButtonColorScheme {
    mutating func toggle() {
        switch self {
        case .light:
            self = .dark
        case .dark:
            self = .red
        case .red:
            self = .blue
        case .blue:
            self = .light
        }
    }
}


