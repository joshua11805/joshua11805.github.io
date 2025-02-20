//
//  FireStoreManager.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

import FirebaseFirestore
import FirebaseFirestoreCombineSwift

//ran into a problem where I want to store the plants
//but since the plants are its own struct and it structs dont come up
//as a data type FireStore natively supports, this will convert it to
//a dictionary
extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data) as? [String : Any])
    }
}

//classic role of Model in MVVM
//this class is to manage any calls to the Firestore database
class FireStoreManager {
    
    let db = Firestore.firestore()
    
//this function will retrieve the plants from Firestore
//Used primarily in the PlantViewModel to populate
//a user's plants upon login, important because
//each user will have their own set of plants
    func retrievePlants(userID: String) async throws -> [Plant]? {
        do {
            //users->userID->plantData->(multiple plant documents)
            //to clarify each user will have their own subcollection plantData
            let snapshot = try await db.collection("users")
                .document(userID)
                .collection("plantData")
                .getDocuments()
            let plants = snapshot.documents.compactMap { document -> Plant? in return try? document.data(as: Plant.self)
            }
            return plants.isEmpty ? nil : plants
        } catch {
            print("Error fetching plants: \(error.localizedDescription)")
            throw error
        }
    }

//called from the PlantEditorView via PVM
//Update in future at Line 58, currently only supporting healthy
    func updatePlant(plant: Plant, userID: String) async throws {
        // Ensure the plant has a valid ID
        guard let plantID = plant.id else {
            throw NSError(domain: "Invalid Plant ID", code: 400, userInfo: nil)
        }
        let plantDataRef = db.collection("users").document(userID).collection("plantData")
        let plantData: [String: Any] = [
            "id": plantID,
            "plantState": PlantState.healthy.rawValue,
            "plantType": plant.plantType.rawValue
        ]
        try await plantDataRef.document(plantID).setData(plantData)
        print("plant\(plantID) successfully added to user: \(userID)")
        let updatedDocument = try await plantDataRef.document(plantID).getDocument()
        if updatedDocument.exists {
            print("Document updated: \(String(describing: updatedDocument.data()))")
        }
    }

    
//incomplete function IGNORE
//Currently using updatePlants as the primary way to persistData and thats all that's necessary
//Question: how should saving plants be handled?
//option 1: Call savePlants upon user exiting
    //but what if the user exits out too fast and it doesn't save plants properly?
//option 2: loadData upon sign-in and updateData depending on healthData
    //this way we will only save changes made to plantData, instead of overwriting the database multiple times
// more smaller calls, or one large batch call?
    func savePlants(_ plants: [Plant?], for userID: String, completion: @escaping (Error?) -> Void) {
//"Creates a write batch, used for performing multiple writes as a single atomic operation."
        let batch = db.batch()
        
        for plant in plants{
            let plantRef = db.collection("users").document(userID).collection("plantData").document()
            do {
                try batch.setData(from: plant, forDocument: plantRef)
            } catch {
                print("Error saving plant: \(error)")
                completion(error)
                return
            }
        }
        batch.commit { error in
            completion(error)
        }
    }
}
