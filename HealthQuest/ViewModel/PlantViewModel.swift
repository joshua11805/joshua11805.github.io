//
//  PlantViewModel.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/4/24.
//
import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class PlantViewModel: ObservableObject{
    
    //@ObservableObject healthDataViewModel: HealthDataViewModel()
    //initializing userID to empty because it wont let me use
    //a function call in the initializer
    // I will definitely have to come back and secure this later
    var userID: String?
    @Published var plants: [Plant?] = Array(repeating: nil, count: 9)
    var plantAssetNames: [String] = Array(repeating: "", count: 9)
    @Published var isLoading: Bool = false
    //the FireStoreManager will manage updates / saves / loads to Firestore
    private var fireStore = FireStoreManager()
    
    init(){
        //placeholder intializer
        self.userID = ""
    }
    
    func getPlantAsset(gridNum: Int) -> String {
        // Ensure index is within bounds
        guard gridNum >= 0 && gridNum < plants.count, let plant = plants[gridNum] else {
            return "placeHolderAsset" // Return a placeholder if plant is nil or index out of bounds
        }
        return plant.plantAssetName // Return the plant's asset name
    }

    func updatePlantState() {
        // Ensure that the plants array is not empty
        guard !plants.isEmpty else {
            print("Plants array is empty.")
            return
        }
        for i in 0..<9 {
            plantAssetNames[i] = getPlantAsset(gridNum: i)
        }
    }
    
    func updatePlant(index: Int, plantType: PlantType) async{
        DispatchQueue.main.async {
            self.plants[index]!.plantType = plantType
        }
        let updatedPlant = Plant(id: plants[index]!.id!, plantType: plantType)
        do {
            try await fireStore.updatePlant(plant: updatedPlant, userID: userID!)
            print("Plant updated successfully.")
        } catch {
            print("Failed to update plant: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.plants[index]!.plantType = plantType
            self.plantAssetNames[index] = self.getPlantAsset(gridNum: index)
        }
    }
    
    func removePlant(index: Int){
        plants[index]!.plantType = .none
    }
    
    @MainActor
    func load(userID: String?) async {
        // Safely unwrap userID
        guard let userID = userID else {
            self.isLoading = false
            print("Invalid User ID")
            return
        }
        
        self.userID = userID
        self.isLoading = true
        do {
            let plants = try await fireStore.retrievePlants(userID: userID)
                self.plants = plants ?? []
                self.isLoading = false
            print("Intialize plant array with \(plants!.count) plants")

        } catch {
            print("Error retrieving plants \(error.localizedDescription)")
        }
        self.updatePlantState()
        self.isLoading = false
    }

    
    func save(_ plants: [Plant?], for userID: String) {
        fireStore.savePlants(plants, for: userID) { error in
            if let error = error {
                print("Error saving plans: \(error.localizedDescription)")
            } else {
                print("Plants saved successfully!")
            }
        }
    }
    
    //we will probably want smaller versions of the load and save functoins
    //for when the player makes small changes during the time they are on the app
}

