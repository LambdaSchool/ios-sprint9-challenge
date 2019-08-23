//
//  ModelController.swift
//  Calorie Tracker
//
//  Created by Cameron Dunn on 3/15/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Model{
    var calorieLogs : [NSManagedObject] = []
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do{
            try moc.save()
        }catch{
            NSLog("Error saving managed object context: \(error)")
        }
    }
    func loadFromPersistentStore(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "CalorieLogStore")
        
        //3
        do {
            calorieLogs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
