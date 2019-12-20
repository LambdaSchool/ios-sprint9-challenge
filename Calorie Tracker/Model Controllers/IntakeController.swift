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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Intake> = {
        
        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true),
                                        NSSortDescriptor(key: "calories", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "date",
                                             cacheName: nil)
        
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        try? frc.performFetch()
        
        return frc
        
    }()
    
    
    // Creating Calorie Intake
    func createIntake(calories: String) {
        
        let caloriesDouble = Double(calories)
        guard let caloriesIntake = caloriesDouble else { return }
        
        Intake(calories: caloriesIntake)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("Intake saved")
            NotificationCenter.default.post(name: .newIntake, object: self)
        } catch {
            NSLog("Error saving new intake in CD : \(error)")
        }
    }
}
