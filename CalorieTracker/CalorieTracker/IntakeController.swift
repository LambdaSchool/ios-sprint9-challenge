//
//  IntakeController.swift
//  CalorieTracker
//
//  Created by Thomas Cacciatore on 7/5/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

class IntakeController {
    
    var intakes: [Intake] = []
    var calories: [Double] = []
    
    func getCaloriesFromIntakes(intakes: [Intake]) {
        for intake in intakes {
            calories.append(intake.calories)
        }
    }
    
    func fetchAllIntakes() {
       
        let intakesFetch = NSFetchRequest<Intake>(entityName: "Intake")
        
        do {
            let moc = CoreDataStack.shared.mainContext
            let fetchedIntakes = try moc.fetch(intakesFetch)
            intakes = fetchedIntakes
        } catch {
            fatalError("Failed to fetch intakes: \(error)")
        }
        
        getCaloriesFromIntakes(intakes: intakes)

    }
    
    func createIntake(with calories: Double, timeStamp: Date = Date()) {
        var _ = Intake(calories: calories, timeStamp: timeStamp)
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}
