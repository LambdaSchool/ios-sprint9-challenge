//
//  CaloriesController.swift
//  CalorieTracker
//
//  Created by Carolyn Lea on 9/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

class CaloriesController
{
    var calorie: Calorie?
    var calories: [Calorie]
    {
        return loadFromCoreData()
    }
    
    func saveToCoreData(context: NSManagedObjectContext)
    {
        context.performAndWait {
            
            let moc = CoreDataStack.shared.mainContext
            
            do
            {
                try moc.save()
            }
            catch
            {
                NSLog("There was an error while saving managed object context: \(error)")
            }
        }
    }
    
    func loadFromCoreData() -> [Calorie]
    {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do
        {
            return try moc.fetch(fetchRequest)
        }
        catch
        {
            NSLog("There was an error while fetching Calories: \(error)")
            return []
        }
    }
    
    func createCalorieEntry(calorieAmount: String, context: NSManagedObjectContext)
    {
        let _ = Calorie(calorieAmount: calorieAmount)
        saveToCoreData(context: context)
    }
    
    func updateCalorieEntry(calorie: Calorie, calorieAmount: String, timestamp: Date = Date(), context: NSManagedObjectContext)
    {
        let calorie = calorie
        calorie.calorieAmount = calorieAmount
        calorie.timestamp = timestamp as Date
        saveToCoreData(context: context)
    }
    
    func deleteCalorieEntry(calorie: Calorie, context: NSManagedObjectContext)
    {
        context.performAndWait {
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(calorie)
            
            do
            {
                try moc.save()
            }
            catch
            {
                moc.reset()
                NSLog("There was an error while saving managed object context: \(error)")
            }
        }
    }
}
