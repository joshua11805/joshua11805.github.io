//
//  HealthViewModel.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

import SwiftUI
import HealthKitUI

class HealthViewModel: ObservableObject {
    @Published var steps: Double = 0
    @Published var isLoading = true
    @Published var isAuthorized = false

    
    var date = Date()
    //private let healthKitManager = HealthKitDataModel()
    let healthStore = HKHealthStore()
    
    //I'm trying to make a function that will check the authorization status
    //and show the appropriate view corresponding to that
    func checkAuthorization() {
         guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
             print("Step count type is not available.")
             self.isAuthorized = false
             return
         }
         
         let status = healthStore.authorizationStatus(for: stepCountType)
         DispatchQueue.main.async {
             switch status {
             case .notDetermined:
                 self.isAuthorized = false
             case .sharingDenied:
                 self.isAuthorized = false
             case .sharingAuthorized:
                 self.isAuthorized = true
             @unknown default:
                 self.isAuthorized = false
             }
             self.isLoading = false
         }
     }
     
    //if user hasn't granted the app health Permissions will ask for persmission
    func requestPermission() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available.")
            return
        }
        //we need to specify what healthData we want which is steps in this case
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        //only asking for read access, if we wanted write access we'd have to declare that as well
        let readTypes: Set<HKObjectType> = [stepCountType]
        
        //gives the user a popup allowing them to grant us persmissions
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                self.isAuthorized = true
                print("HealthKit authorization granted.")
                self.fetchStepCount() // Fetch data after permission is granted
            } else {
                self.isAuthorized = false
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchStepCount() {
        //specifying the type
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            if let error = error {
                print("Error fetching step count: \(error.localizedDescription)")
                return
            }
            
            if let result = result {
                let totalSteps = result.sumQuantity()?.doubleValue(for: .count())
                print("Total steps: \(totalSteps ?? 0)")
                self.steps = totalSteps!
            }
        }
        
        healthStore.execute(query)
    }
    
    func saveStepCount(steps: Double) {
        //going to hold off on saving healthData for now
        //probably going to keep it in the Firestore database
        //but idk if thats TOS violation or not
    }
}
