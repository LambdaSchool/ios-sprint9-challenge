//
//  CalorieCountController.swift
//  CalorieTracker
//
//  Created by Kat Milton on 8/23/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

class CalorieCountController {
    
    func createEntry(with intakeAmount: String, date: Date? = Date()) -> CalorieCount {
        let calorieCount = CalorieCount(intakeNumber: intakeAmount, date: date)
        saveToCoreDataStack(nsLogMessage: "createEntry: Error saving context: ")
        return calorieCount
    }
    
    func deleteEntry(calorieCount: CalorieCount) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorieCount)
        saveToCoreDataStack(nsLogMessage: "deleteEntry: Error saving context: ")
    }
    
    private func updateEntries(with representations: [CalorieCountRepresentation], context: NSManagedObjectContext) {
        
        context.performAndWait {
            
            for representation in representations {
                guard let date = representation.date else { return }
                
                if let calorieCount = entry(for: date, context: context) {
                    calorieCount.date = representation.date
                    calorieCount.intakeNumber = representation.intakeNumber
                } else {
                  CalorieCount(calorieCountRepresentation: representation, context: context)
                }
            }
        }
    }
    
    private func entry(for date: Date, context: NSManagedObjectContext) -> CalorieCount? {
        let fetchRequest: NSFetchRequest<CalorieCount> = CalorieCount.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.predicate = predicate
        
        var result: CalorieCount? = nil
        
        context.performAndWait {
            do {
                let calorieCount = try context.fetch(fetchRequest).first
                result = calorieCount
            } catch {
                NSLog("Error fetching calorieCount from date: \(date.timeIntervalSince1970): \(error)")
            }
        }
        return result
    }
    
    
    
    func saveToCoreDataStack(nsLogMessage: String) {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog(nsLogMessage, "\(error)")
        }
    }
    
}
