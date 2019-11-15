//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Gi Pyo Kim on 11/15/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func createCalorie(calorie: Int16, date: Date, context: NSManagedObjectContext) {
        Calorie(calorie: calorie, date: date, context: context)
        CoreDataStack.shared.save(context: context)
    }
}
