//
//  IntakeController.swift
//  SmartCal
//
//  Created by Farhan on 10/26/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData

class IntakeController {
    
//    var dataPoints: [Intake] = []
    
    func createDataPoint(with calories: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let _ = Intake(calories: calories)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving book: \(error)")
        }
        
    }
    
    func deleteDataPoint(point: Intake){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(point)
        try? moc.save()
        
    }
    
}
