//
//  HealthKitHelper.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 2/15/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import HealthKit

/// Class to take care of Health Kit related tasks
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
    
    /// Requests authorization from the user to read and write their calorie data.
    func requestAuthorization(completion: @escaping (_ success: Bool) -> Void) {
        guard let store = store else { completion(false); return }
        let type = Set([HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!])
        store.requestAuthorization(toShare: type, read: type, completion: { (success, error) in
            if let error = error {
                NSLog("Error requesting permission: \(error)")
            }
            completion(success)
        })
    }
    
    /// Fetches calorie data from the Health Kit store. Returns only calories written by this app if read access is denied.
    func fetchCalorieData(for day: Date = Date(), completion: @escaping ([CalorieData]) -> Void) {
        
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
            
            var calorieDatas: [CalorieData] = []
            guard let samples = results as? [HKQuantitySample] else {
                NSLog("An error occured fetching the user's calorie data: \(error!.localizedDescription)")
                completion(calorieDatas)
                return
            }
            
            for sample in samples {
                let calories = sample.quantity.doubleValue(for: .kilocalorie())
                let timestamp = sample.startDate
                
                let calorieData = CalorieData(calories: calories, timestamp: timestamp)
                calorieDatas.append(calorieData)
            }
            completion(calorieDatas)
        }
        
        store?.execute(query)
    }
    
    /// Saves a new calories data sample to the Health Kit store
    func saveCalorieData(_ calorieData: CalorieData) {
        // TODO: Verify that the app has permission to write to the health kit store and handle it in some way (let the user know) if it can't write to the Health Kit store.
        
        guard let object = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("This should never fail.")
        }
        
        let quantity = HKQuantity(unit: .kilocalorie(), doubleValue: calorieData.calories)
        let sample = HKQuantitySample(type: object, quantity: quantity, start: calorieData.timestamp, end: calorieData.timestamp)
        
        store?.save(sample, withCompletion: { (_, error) in
            if let error = error {
                NSLog("Error saving calorie: \(error)")
            }
        })
    }
}
