//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Andrew Liao on 9/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

private let moc = CoreDataStack.shared.mainContext

class EntryController {
    
    
    //CRUD Method
    func create(withCalories calories: Int){
         Entry(calories: calories)
        save()
    }
    
    func save(){
        moc.perform {
            
            do {
                try moc.save()
            } catch {
                NSLog("Error saving")
                moc.reset()
            }
        }
    }
}
