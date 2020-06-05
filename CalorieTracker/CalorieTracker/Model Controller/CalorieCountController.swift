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
}

extension NSNotification.Name {
    static let caloriesUpdated = NSNotification.Name("caloriesUpdated")
}
