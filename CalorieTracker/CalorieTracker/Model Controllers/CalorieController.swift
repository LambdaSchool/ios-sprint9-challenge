//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Madison Waters on 2/16/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreData

extension Notification.Name {
    static let caloriesDidChange = Notification.Name("caloriesDidChange")
}

class CalorieController {
    
    var calories: [Calorie] = []
    
    var chartCalories: [Double] = []
    
    var calorieValueChanged: Bool {
        get { return self.calorieValueChanged }
        set { NotificationCenter.default.post(name: .caloriesDidChange, object: self) }
    }
    
    let moc = CoreDataStack.shared.mainContext
    
    func calorieCount() -> Int {
        return calories.count
    }
    
    func addCalorie(calorie: String) {
        let newCalories = Calorie(value: calorie, timestamp: Date.init(), context: moc)
        calories.append(newCalories)
        
        do { try moc.save() }
        catch { NSLog("Error saving to managed object context") }
    }
    
    func chartCalorie(calorie: Double) {
        chartCalories.append(calorie)
        
        do { try moc.save() }
        catch { NSLog("Error saving to managed object context") }
    }
    
    func fetchCalories() -> [Calorie] {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<Calorie>(entityName: "Calorie")
        var results: [Calorie] = []
        
        do {
            results = try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Calorie data from moc")
        }
        return results
    }
    
}
