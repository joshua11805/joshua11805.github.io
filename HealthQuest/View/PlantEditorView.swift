//
//  QuestPage.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

import SwiftUI

struct PlantEditorView: View {
    @EnvironmentObject var plantViewModel: PlantViewModel
    @State private var selectedPlantIndex: Int = 0
    @State private var plantType: PlantType = .none
    
    var body: some View {
        VStack {
            Text("Edit Plant")
                .font(.title)
                .padding()
            
            //picker to pick plant to update
            Picker("Select Plant", selection: $selectedPlantIndex) {
                ForEach(0..<plantViewModel.plants.count, id: \.self) { index in
                    Text(plantViewModel.plants[index]!.id!)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Form {
                Section(header: Text("Plant Type")) {
                    //picker to choose what plantType to update plant to
                    Picker("Select Plant Type", selection: $plantType) {
                        ForEach(PlantType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                // button to update plant
                Button(action: {
                    Task{
                        await plantViewModel.updatePlant(index: selectedPlantIndex, plantType: plantType)
                    }
                }) {
                    Text("Update Plant")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                // just updates the plantType to be .none
                Button(action: {
                    Task{
                        await plantViewModel.updatePlant(index: selectedPlantIndex, plantType: .none)
                    }
                }) {
                    Text("Remove Plant")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
        }
        .padding()
        .onAppear {
            // Initialize the selectedPlantType when the view appears
            plantType = plantViewModel.plants[selectedPlantIndex]!.plantType
        }
        .padding()
        
    }
}

#Preview {
    PlantEditorView()
        .environmentObject(PlantViewModel())
}
