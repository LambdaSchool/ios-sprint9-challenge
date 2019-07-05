//
//  IntakeController.swift
//  CalorieTracker
//
//  Created by Thomas Cacciatore on 7/5/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation
import CoreData

class IntakeController {
    
    
    
    
    
    
    func createIntake(with calories: Int32, timeStamp: Date = Date()) {
        var _ = Intake(calories: calories, timeStamp: timeStamp)
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}
