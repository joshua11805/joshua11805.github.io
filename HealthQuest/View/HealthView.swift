//
//  HealthView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/11/24.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct HealthView: View {
    @StateObject private var healthKitManager = HealthViewModel()
    var body: some View {
        VStack {
            if healthKitManager.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if healthKitManager.isAuthorized {
                Text("Steps for this week:")
                    .font(.headline)
                    .padding()
                
                Text("\(Int(healthKitManager.steps)) steps")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            } else if !healthKitManager.isLoading{
                Text("HealthKit permissions not granted.")
                    .foregroundColor(.red)
                    .padding()
                
                Button("Request Permission") {
                    healthKitManager.requestPermission()
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            healthKitManager.checkAuthorization()
            if healthKitManager.isAuthorized{
                healthKitManager.fetchStepCount()
            }
        }
    }
}
