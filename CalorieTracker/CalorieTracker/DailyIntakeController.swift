//
//  DailyIntakeController.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

class DailyIntakeController {
    
    // MARK: - CRUD Methods
    
    func add(calories: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let dailyIntake = DailyIntake(calories: calories)
        dailyIntakes.append(dailyIntake)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving new daily intake to core data.")
        }
    }
    
    // MARK: - Properties
    
    private(set) var dailyIntakes: [DailyIntake] = []
}
