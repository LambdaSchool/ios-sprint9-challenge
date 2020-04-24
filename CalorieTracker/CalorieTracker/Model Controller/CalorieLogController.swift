//
//  CalorieLogController.swift
//  CalorieTracker
//
//  Created by Kobe McKee on 6/28/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreData

class CalorieLogController {
    
    var calorieLogs: [Calorie] {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Calorie")
            return []
        }
    }
    
    
    func logCalories(calories: String) {
        guard let calorieCount = Int32(calories) else { return }
        
        Calorie(calories: calorieCount)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving Calorie :\(error)")
        }
        
        NotificationCenter.default.post(name: .calorieAdded, object: nil, userInfo: nil)
        
        
    }
    
    
    
    
    
    
    
}
