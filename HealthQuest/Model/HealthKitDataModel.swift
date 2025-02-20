//
//  HealthKitManager.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/3/24.
//

import HealthKit
import Foundation

//IGNORE, look at HealthViewModel as all functions here are being done there
//This is because healthViewModel doesn't have any other responsibilities
//but all calls made to HealthKit and/or Firestore will be handled here
//class HealthKitDataModel {
//    private let healthStore = HKHealthStore()
//    
//    
//    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void){
//        //specifying which healthMetrics we want access to
//        guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
//        else {
//            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step Count unavailable"]))
//            return
//        }
//        //accessing write access (we dont need it but might as well)
//        let typesToShare: Set = Set([stepCount])
//        //accessing read data (we very much need this)
//        let typesToRead: Set = Set([stepCount])
//        
//        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
//            DispatchQueue.main.async{
//                completion(success, error)
//            }
//        }
//    }
//    // Function to get step count data for a specific date range
//    func getStepCountData(completion: @escaping (Double?, Error?) -> Void){
//        // Define the quantity type for step count
//        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
//            completion(nil, NSError(domain: "HealthKitError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch step count type"]))
//            return
//        }
//        
//        // Create a date range (e.g., today)
//        let calendar = Calendar.current
//        let now = Date()
//        let startOfDay = calendar.startOfDay(for: now)
//        
//        // Create a predicate to filter data
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//        
//        // Create the query to get step count data
//        let query = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
//            guard error == nil else {
//                print("Error fetching step count data: \(error!.localizedDescription)")
//                completion(nil, error)
//                return
//            }
//            
//            // Process the results
//            if let results = results as? [HKQuantitySample] {
//                let totalSteps = results.reduce(0) { $0 + $1.quantity.doubleValue(for: .count()) }
//                print("Total steps: \(totalSteps)")
//                completion(totalSteps, nil)
//            } else {
//                completion(nil, NSError(domain: "HealthKitError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No step data found"]))
//            }
//        }
//        
//        // Execute the query
//        healthStore.execute(query)
//    }
//}

