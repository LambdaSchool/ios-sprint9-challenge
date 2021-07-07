//
//  CalorieController.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class CalorieController
{
    private(set) var calories = [Calorie]()
    
    func createNewCalorieEntry(calories: Int16, id: String, date: Date)
    {
        let entry = Calorie(calories: calories, id: id, date: date)
        self.calories.append(entry)
        
        let nc = NotificationCenter.default
        nc.post(name: .newEntryWasCreated, object: self, userInfo: ["calories": calories])
    }
    
    func fetch(completion: @escaping () -> ())
    {
        let backgroundMoc = CoreDataManager.shared.container.newBackgroundContext()
        
        FirebaseManager.shared.fetchFromDatabase { (calorieRep) in
            
            if let _ = self.fetchSingleCalorieFromPersistence(identifier: calorieRep.identifier, context: backgroundMoc)
            {
                //do nothing
            }
            else
            {
                let _ = Calorie(calorieRepresentation: calorieRep, context: backgroundMoc)
            }

            do {
                try CoreDataManager.shared.saveContext(context: backgroundMoc)
                
                let fetchRequest = NSFetchRequest<Calorie>(entityName: "Calorie")
                fetchRequest.returnsObjectsAsFaults = false
                do {
                    let calories = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
                    self.calories = calories
                    completion()
                } catch let fetchError {
                    NSLog(fetchError as! String)
                }
            } catch let saveError {
                NSLog(saveError as! String)
            }
        }
    }
    
    private func fetchSingleCalorieFromPersistence(identifier: String, context: NSManagedObjectContext) -> Calorie?
    {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        do {
            let moc = CoreDataManager.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching calorie: \(error)")
            return nil
        }
    }
}
