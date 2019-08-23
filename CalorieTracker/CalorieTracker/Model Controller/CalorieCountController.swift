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
    
   
    
    func createEntry(with intakeAmount: Double) {
        let calorieCount = CalorieCount(intakeNumber: intakeAmount)
        let moc = CoreDataStack.shared.mainContext
       
            do {
                try moc.save()
            } catch {
                NSLog("Error saving entry to context: \(error)")
            }
        
      
    }
    
//    func deleteEntry(calorieCount: CalorieCount) {
//        let moc = CoreDataStack.shared.mainContext
//        moc.delete(calorieCount)
//        saveToCoreDataStack(nsLogMessage: "deleteEntry: Error saving context: ")
//    }
    
//    private func updateEntries(with representations: [CalorieCountRepresentation], context: NSManagedObjectContext) {
//
//        context.performAndWait {
//
//            for representation in representations {
//                guard let date = representation.date,
//                    let intakeNumber = representation.intakeNumber else { return }
//
//                if let calorieCount = entry(for: date, context: context) {
//                    calorieCount.date = date
//                    calorieCount.intakeNumber = intakeNumber
//                } else {
//                  CalorieCount(calorieCountRepresentation: representation, context: context)
//                }
//            }
//        }
//    }
    
//    func fetchEntries(context: NSManagedObjectContext) -> [CalorieCount]? {
//        let fetchRequest: NSFetchRequest<CalorieCount> = CalorieCount.fetchRequest()
////        let predicate = NSPredicate(format: "date == %@", date as NSDate)
////        fetchRequest.predicate = predicate
////
//        var result: [CalorieCount]? = []
//
//        context.performAndWait {
//            do {
//                let calorieCount = try context.fetch(fetchRequest)
//                result = calorieCount
//            } catch {
//                NSLog("Error fetching calorieCount: \(error)")
//            }
//        }
//        return result
//    }
//
//
//
//    func saveToCoreDataStack(nsLogMessage: String) {
//
//        do {
//            try CoreDataStack.shared.save()
//        } catch {
//            NSLog(nsLogMessage, "\(error)")
//        }
//    }
    
}

extension NSNotification.Name {
    static let caloriesUpdated = NSNotification.Name("caloriesUpdated")
}
