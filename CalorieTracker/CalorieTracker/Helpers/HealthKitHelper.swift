//
//  HealthKitHelper.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 2/15/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitHelper {
    
    static let shared = HealthKitHelper()
    let store: HKHealthStore?
    
    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        } else {
            store = nil
        }
    }
    
    
    func requestAuthorization() {
        let type = Set([HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!])
        store?.requestAuthorization(toShare: type, read: type, completion: { (success, error) in
            if let error = error {
                NSLog("Error requesting permission: \(error)")
            }
        })
    }
    
    func fetchCalorieData(for day: Date = Date(), completion: @escaping ([NewCalorieData]) -> Void) {
        
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.hour = 1
        
        let anchorcomponents = calendar.dateComponents([.day, .month, .year], from: day)
        
        guard let startDate = calendar.date(from: anchorcomponents), let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("Unable to make proper date.")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("Unable to create a calorie count type")
        }
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error!.localizedDescription)");
            }
            
            var results: [NewCalorieData] = []
            for sample in samples {
                let calories = sample.quantity.doubleValue(for: .kilocalorie())
                let timestamp = sample.startDate
                
                let calorieData = NewCalorieData(calories: calories, timestamp: timestamp)
                results.append(calorieData)
            }
            completion(results)
        }
        
        store?.execute(query)
    }
}
