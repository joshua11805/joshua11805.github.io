//
//  ContentView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/1/24.
//

import SwiftUI

struct MainView: View {
    
    //@State private var healthState: HealthState
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var plantViewModel: PlantViewModel
    @State var audioController = AudioPlayerViewModel()
    
    
    let firstRowWidth: CGFloat = 90
    let firstRowHeight: CGFloat = 144
    let secondRowWidth: CGFloat = 80
    let secondRowHeight: CGFloat = 130
    let thirdRowWidth: CGFloat = 75
    let thirdRowHeight: CGFloat = 112
//    let fourthRowWidth: CGFloat = 65
//    let fourthRowHeight: CGFloat = 94
    
    
//the way this view is formatted is a ZStack with plants organized into rows
//via grids and grid rows. It is designed this way because it allows the plants
//to grow and overlap other plants while maintaining a semi-realistic POV
    var body: some View {
        NavigationView{
            ZStack{
                //background
                VStack {
                    Image("healthBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                }
                .onAppear {
                    audioController.playOrPause()
                }
                .onDisappear {
                    audioController.playOrPause()
                }
                Grid{
                    GridRow{
                        Image("\(plantViewModel.plantAssetNames[0])") // 4th slot
                            .resizable()
                            .frame(width: thirdRowWidth, height: thirdRowHeight)
                        Image("\(plantViewModel.plantAssetNames[1])") // 5th slot
                            .resizable()
                            .frame(width: thirdRowWidth, height: thirdRowHeight)
                        
                    }
                }
                .offset(x: -60, y: 50)
                Grid {
                    GridRow {
                        Image("\(plantViewModel.plantAssetNames[2])") // 6th slot
                            .resizable()
                            .frame(width: secondRowWidth, height: secondRowHeight)
                        Image("\(plantViewModel.plantAssetNames[3])")
                            .resizable() // 7th slot
                            .frame(width: secondRowWidth, height: secondRowHeight)
                        Image("\(plantViewModel.plantAssetNames[4])") // 8th slot
                            .resizable()
                            .frame(width: secondRowWidth, height: secondRowHeight)
                        Image("\(plantViewModel.plantAssetNames[5])") // 9th slot
                            .resizable()
                            .frame(width: secondRowWidth, height: secondRowHeight)
                    }
                }
                .offset(x: -10, y: 125)
                Grid{
                    GridRow{
                        Image("\(plantViewModel.plantAssetNames[6])") // 9th slot
                            .resizable()
                            .frame(width: firstRowWidth, height: firstRowHeight)
                        Image("\(plantViewModel.plantAssetNames[7])") // 10th slot
                            .resizable()
                            .frame(width: firstRowWidth, height: firstRowHeight)
                        Image("\(plantViewModel.plantAssetNames[8])") // 11th slot
                            .resizable()
                            .frame(width: firstRowWidth, height: firstRowHeight)
                        
                    }
                }
                .offset(x: -5, y: 225)
                
                VStack(alignment: .leading, spacing: 20){
                    Spacer()
                    HStack{
                        NavigationLink(destination: SettingsView().environmentObject(authController)){
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .foregroundColor(.black)
                            Text("Settings")
                                .foregroundColor(.black)
                        }
                        NavigationLink(destination: PlantEditorView().environmentObject(plantViewModel)){
                            Image(systemName: "leaf.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.black)
                            
                            Text("Plants")
                                .foregroundColor(.black)
                        }
                        NavigationLink(destination: HealthView()){
                            Image(systemName: "figure")
                                .imageScale(.large)
                                .foregroundColor(.black)
                            
                            Text("Steps")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .offset(x: 10, y: -40)

                }
            }
        }
    }
}

//struct PlantView: View {
//        @State private var healthState: HealthState
//        var body: some View {
//            Image("tree")
//        }
//    }
//    
//}

#Preview {
    MainView()
        .environmentObject(AuthController())
        .environmentObject(PlantViewModel())
}
