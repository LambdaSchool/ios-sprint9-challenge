//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Linh Bouniol on 9/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    var calories: [Calorie] {
        return loadFromCoreData()
    }
    
    func create(calorie: Int64) {
        let _ = Calorie(calorie: calorie)
        
        saveToCoreData()
    }
    
    // MARK: - Persistence
    
    func saveToCoreData() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving calories: \(error)")
        }
    }
    
    func loadFromCoreData() -> [Calorie] {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching calories: \(error)")
            return []
        }
    }
    
}
