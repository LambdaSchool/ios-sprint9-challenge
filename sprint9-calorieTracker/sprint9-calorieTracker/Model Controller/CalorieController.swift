//
//  calorieController.swift
//  sprint9-calorieTracker
//
//  Created by Nikita Thomas on 1/11/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import CoreData

class CalorieController {
    
    static let shared = CalorieController()
    
    var entries: [NSManagedObject] = []
    
    
    func saveEntry(withCalories calories: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        entry.setValue(Int16(calories), forKey: "calories")
        entry.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
            entries.append(entry)
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    
    
    func getEntries() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entry")
        
        do {
            entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
}
