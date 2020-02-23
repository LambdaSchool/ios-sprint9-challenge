//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CalorieController {
    func create(calorie: Int16) {
        let calorie = Calorie(calorie: calorie)
        
        calories.append(calorie)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving to core data: \(error)")
        }
    }
    
    var calories: [Calorie] = []
    
    func fetch() {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let calories = try moc.fetch(fetchRequest)
            for calorie in calories {
                print(calorie)
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }
}
