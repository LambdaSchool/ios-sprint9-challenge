//
//  CalorieEntryController.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    typealias CompletionHandlerStandard = (Error?) -> Void
    
    func addUserEnteredData(calorieEntry: CalorieEntry) {
        
        //append calorie integer to calories array to show in the chart
        
        
        
        // Save to Core Data0
        // this saves our data, but should i call calorieEntryController instead of doing it here?
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        print("Appending the user-entered daily calorie count to model array")
    }
    
    func fetchCalorieArray() {
        
        // not sure i really need this at all, as calorie array is already in tableView if I want it.
    }
    
    var calories = {
        
        
    }
    
    
    
    var calorieEntry = CalorieEntry()
    //var calories: [CalorieEntry.calorie] = []   // can i get away with just CalorieEntry as the type?
    

}
