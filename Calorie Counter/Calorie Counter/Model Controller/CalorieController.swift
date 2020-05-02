//
//  CalorieController.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart


class CalorieController {
    
    var calories: [Double] = []
    
    func delete(for calories: Calorie) {
        CoreDataStack.shared.mainContext.delete(calories)
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving Managed Object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func addCalorieEntry(calories: Double) -> [Double] {
        var caloriesArray: [Double] = []
        caloriesArray.append(calories)
        return caloriesArray
        
        //TODO Notification observers will go here
        
    }
}
