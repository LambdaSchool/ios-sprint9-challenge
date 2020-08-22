//
//  CalorieController.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    var calrories : [Calorie] = []
    
    func createNewItem(amount: Double, date: Date = Date() ,into context : NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        
        let newItem = Calorie(context: context)
        calrories.append(newItem)
        newItem.amount = Double(amount)
        newItem.date = date
        
        do {
            try    CoreDataStack.shared.mainContext.save()
        } catch let err as NSError {
            NSLog("Error saving data to storage: \(err)")
        }
     
    }
    
    func deleteItem(calorie: Calorie) {
        CoreDataStack.shared.mainContext.delete(calorie)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let err as NSError {
            NSLog("Error deleting item : \(err)")
        }
    }
}
