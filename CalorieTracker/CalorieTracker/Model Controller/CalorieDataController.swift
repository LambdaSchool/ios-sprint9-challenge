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
    private(set) var calorieData: [Calories] = []
    
    init() {
        
    }
    
    @discardableResult func addCount (_ count: Int, _ date: Date = Date()) -> Calories {
        let calories = Calories(count)
        NotificationCenter.default.post(name: .dataWasAdded, object: self)
        calorieData.append(calories)
        CoreDataStack.shared.save()
        return calories
    }
    
}
