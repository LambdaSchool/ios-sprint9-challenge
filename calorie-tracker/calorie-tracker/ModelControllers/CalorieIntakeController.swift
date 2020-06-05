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
    
    func create(with calories: Int16, for person: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = CalorieIntake(person: person, calorie: calories)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving calorie intake: \(error)")
        }
        
    }
    
}
