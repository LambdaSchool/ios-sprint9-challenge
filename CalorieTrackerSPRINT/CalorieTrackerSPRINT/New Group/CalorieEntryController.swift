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
    
    func addUserEnteredData(calorie: Double) {
        
        //append calorie integer to calories array to show in the chart
        
        let newEntry = CalorieEntry(calorie: calorie)
        calories.append(calorie)
        
        
        
        // Save timestamped calorieEntry to Core Data0
        // this saves our data, but should i call calorieEntryController instead of doing it here?
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func fetchCalorieArray() {
        
        // not sure i really need this at all, as calorie array is already available via 
    }
    
    var calories: [Double] = []
    
    
    
    var calorieEntry = CalorieEntry()
    //var calories: [CalorieEntry.calorie] = []   // can i get away with just CalorieEntry as the type?
    

}
