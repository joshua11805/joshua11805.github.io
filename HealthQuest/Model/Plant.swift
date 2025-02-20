//
//  Plant.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift


enum PlantType: String, Codable, CaseIterable{
    case none
    case tier1
    case tier2
    case tier3
}

//IGNORE plantState property, will be relevant for future functionality
//but for ITP 342 only plantType matters.
enum PlantState: Int, Codable{
    case dead = -50
    case baby = -1
    case healthy = 0
    case unhealthy = 1
    case dying = 2
}


struct Plant: Identifiable, Codable{
//As of 12/11/2024 plants are stored as plant((Int)id), but in the future
//I will consider using UUID()
    @DocumentID var id: String?
    //plantType is essentially plantName
    var plantType: PlantType
    //this property doesn't need to exist, but in the future
    
    //if each type only corresponds to one plant/asset why is this a seperate computed property?
    //in the future plantState will determine what version of plantType asset is presented on screen.
    var plantAssetName: String {
        get {
            switch plantType{
            case .none: "placeHolderAsset"
            case .tier1: "tier1"
            case .tier2: "tier2"
            case .tier3: "tier3"
            }
        }
    }
    //plantType will control the asset used to display the plant
    //in the future it will also control the plants resilience
    var plantState: PlantState
    
    
    init(plantType: PlantType) {
        let uuid = UUID()
        self.id = uuid.uuidString
        self.plantType = plantType
        self.plantState = .baby
        //self.gridPlacement = gridPlacement
    }
    
    //second intializer is used to copy a plant item one for one without
    //creating a new ID, used in updatePlants in the FireStoreManager
    init(id: String, plantType: PlantType) {
        self.id = id
        self.plantType = plantType
        self.plantState = .baby
        //self.gridPlacement = gridPlacement
    }

    
    func returnPlantType() -> String{
        return plantAssetName;
    }
    
//not relevant for current project
    mutating func deletePlant(){
        self.plantType = .none
        self.plantState = .dead
        //self.gridPlacement = nil
    }
    
    //not relevant for current project
    //business logic to manage how healthData will impact the plantState
    mutating func updatePlantState(update: Int){
        //guards against invalid update requests
        if(update > 2 || update < -2){
            print("Invalid Plant health update request")
        }
        let newState = plantState.rawValue + update
        //case where player is making progress and plant is a sapling
        //it will grow up
        if(plantState == .baby){
            if(update >= 0){
                self.plantState = .healthy
            }
            else{
                return;
                //dont kill off the children :(
            }
        }
        if(newState >= -2)
        {
            self.plantState = .healthy
        }
        else if(newState == -1){
            self.plantState = .healthy
        }
        else if(newState == 0){
            self.plantState = .healthy
        }
        else if(newState == 1){
            self.plantState = .unhealthy
        }
        else if(newState == 2){
            self.plantState = .dying
        }
        else{
            self.plantState = .dead
            self.plantType = .none
            //self.gridPlacement = nil
        }
    }
    
    
}
