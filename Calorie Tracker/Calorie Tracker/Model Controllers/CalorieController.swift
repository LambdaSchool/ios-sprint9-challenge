//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    // MARK: - Properties
    
    private(set) var calorieEntries: [Calories] = []
    private var importer: CoreDataImporter?
    
    // MARK: - CRUD Methods
    
    func createEnry(withCalorieCount count: Int) {
        let entry = Calories(count: count)
        calorieEntries.append(entry)
        saveToPersistentStore()
    }
    
    func updateEntries(with representation: [CalorieRepresentation],
                       in context: NSManagedObjectContext,
                       completion: @escaping ((Error?) -> Void) = { _ in }) {
        importer = CoreDataImporter.init(context: context)
        importer?.sync(entries: representation, completion: { (error) in
            if let error = error  {
                NSLog("Error syncing entries from context: \(error)")
                completion(error)
                return
            }
            
            context.perform {
                do{
                    try context.save()
                    completion(nil)
                } catch {
                    NSLog("Error saving sync context: \(error)")
                    completion(error)
                    return
                }
            }
            
            
        })
    }
    
    // MARK: - Private Methods
    
    private func saveToPersistentStore() {
        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
