//
//  CaloriesController.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class IntakeController {
    
    var intakes: [Intake] = []
    
//    var intakes: [Intake] {
//        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//
//        let moc = CoreDataStack.shared.mainContext
//
//        do{
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching calories intake:\(error)")
//            return []
//        }
//    }
    
    func fetchAllIntakes() {
//        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
//
//        fetchRequest.predicate = NSPredicate(format: "calories IN %@", intakes)
//
//        let existingTasks = try context.fetch(fetchRequest)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            
        
        do {
            
            let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "calories IN %@", self.intakes)
            
            let existingTasks = try context.fetch(fetchRequest)

        } catch {
            NSLog("Error fetching tasks from persistent store: \(error)")
        }
//        }

    }
        
    }
    
    // CRUD
    
    // Create
    
    func createIntake(calories: Int16, context: NSManagedObjectContext) {
        let newIntake = Intake(calories: calories, context: context)
        intakes.append(newIntake)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Update
    
    func updateIntake(intake: Intake, calories: Int16, date: Date = Date()) {
        intake.calories = calories
        intake.date = date
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Delete
    
//    func deleteIntake(intake: Intake, context: NSManagedObject) {
//        context.delete
//        
//        context.validateForDelete(intake)
//    }
}

