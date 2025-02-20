//
//  LaunchPage.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

//the entire purpose of this page is to
//manage loading

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject private var authController: AuthController
    @StateObject var plantViewModel = PlantViewModel()
    //@State private var isLoading: Bool = true
    var body: some View {
        VStack{
            if plantViewModel.isLoading{
                ProgressView("Loading Plant Data")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                MainView()
                    .environmentObject(plantViewModel)
                    .environmentObject(authController)
            }
        }
        .onAppear{
            if !plantViewModel.isLoading{
                Task{
                    await loadData()
                }
            }
        }
        
        
    }
    
    func loadData() async{
        await plantViewModel.load(userID: authController.getUserID())
    }
}

#Preview {
    LaunchView()
        .environmentObject(AuthController())
}
