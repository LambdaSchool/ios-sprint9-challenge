//
//  CalorieIntakeController.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CalorieIntakeController {
    
    func create(with calories: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = CalorieIntake(calorie: calories)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving calorie intake: \(error)")
        }
        
    }
    
}
