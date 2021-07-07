//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_214 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CalorieDataController {
    private(set) var calorieData: [Calories]
    
    init() {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        do {
            let calories = try context.fetch(fetchRequest)
            self.calorieData = calories
        } catch {
            NSLog("Error fetching calories: \(error)")
            calorieData = []
        }
    }
    
    @discardableResult func addCount (_ count: Int, _ date: Date = Date()) -> Calories {
        let calories = Calories(count)
        calorieData.append(calories)
        CoreDataStack.shared.save()
        NotificationCenter.default.post(name: .dataWasAdded, object: self)
        return calories
    }
    
}
