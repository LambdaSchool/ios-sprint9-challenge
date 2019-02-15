//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class CalorieDataController {
    // MARK: - Properties
    private(set) var calorieDatas: [NewCalorieData] = [] {
        didSet {
            // Notify the observers that the data has been updated.
            NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
        }
    }
    
    let healthKit = HealthKitHelper.shared
    
    // MARK: - Properties
    init() {
        fetchHealthKitCalories()
    }
    
    // MARK: - CRUD Methods
    func createCalorieData(calories: Double, timestamp: Date = Date(), id: String = UUID().uuidString) {
        let newCalorie = CalorieData(calories: calories, timestamp: timestamp, id: id)
        
//        calorieDatas.append(newCalorie)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    private func saveToPersistentStore() {
        let mainContext = CoreDataStack.shared.mainContext
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch {
                NSLog("Error saving main object context: \(error)")
            }
        }
    }
    
    func fetchCalories(){
        let fetchRequest: NSFetchRequest<CalorieData> = CalorieData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
//            calorieDatas = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Calories to main object context: \(error)")
        }
    }
    
    func fetchHealthKitCalories() {
        healthKit.fetchCalorieData { (calories) in
            self.calorieDatas = calories
        }
    }
}
