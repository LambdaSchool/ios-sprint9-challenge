//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Chad Rutherford on 1/31/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
//

import Foundation

class CalorieController {
    
    func addEntry(calories: Int, date: Date) {
        Entry(calories: calories, date: date)
        do {
            try CoreDataStack.shared.save()
            NotificationCenter.default.post(name: .calorieEntered, object: nil)
        } catch {
            print(CoreDataError.saveError.localizedDescription)
        }
    }
}
