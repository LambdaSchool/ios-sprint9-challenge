//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 7/5/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    init(){
        calories = loadFromPersistentStore()
    }
    
    var calories: [Calorie] = []
    
    func addCalorie(with amount: Int){
        let calorie = Calorie(amount: amount)
        calories.append(calorie)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error trying to save to persistent store: \(error.localizedDescription), a better description: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Calorie] {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
           let results =  try moc.fetch(fetchRequest)
            return results
        } catch  {
            print("Error trying to load calories from persistent store: \(error.localizedDescription), a better description: \(error)")
            return []
        }
    }
}
