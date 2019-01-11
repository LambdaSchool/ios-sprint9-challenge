//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Welinkton on 1/11/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import Foundation
import CoreData

class CalorieIntakeController {
    
    
    
    // make an empty array to hold all the calories
    private(set) var caloricIntake: [CalorieIntake] = []
    
    // add calories to the data model
    func add(calories:Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let calorieIntake = CalorieIntake(calories: Int(calories))
        caloricIntake.append(calorieIntake)
        
        // do try for coredata model
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("CoreData is not working.. Try again")
        }
    }
    
}


// Do i need to make a whole new file?
// this extension should work.
extension CalorieIntake {
    
    convenience init(calories: Int, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = Int16(calories) /// ???
        self.date = date
    }
    
}
