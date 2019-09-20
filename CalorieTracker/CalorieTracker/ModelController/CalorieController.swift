//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Bradley Yin on 9/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func createCalorie(count: Double, date: Date = Date()) {
        let _ = Calorie(count: count, date: date)
        saveToPersistence()
    }
    
    
    
    func saveToPersistence() {
        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("saving error: \(error)")
        }
    }
}
