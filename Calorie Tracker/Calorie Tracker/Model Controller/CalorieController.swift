//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    var allInputs: [CalorieTracker] = []
    
    func addCalories(calorie: String, date: Date, context: NSManagedObjectContext) {
        let intake = CalorieTracker(calorie: calorie, date: date, context: context)
        CoreDataStack.shared.save(context: context)
        allInputs.append(intake)
    }
}
