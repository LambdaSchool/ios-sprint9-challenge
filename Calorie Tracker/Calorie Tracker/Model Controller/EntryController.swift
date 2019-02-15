//
//  EntryController.swift
//  Calorie Tracker
//
//  Created by Iyin Raphael on 10/26/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

let moc = CoreDataStack.shared.mainContext

class EntryController {
    
    init(){
        fetchEntriesFromServer()
    }
    
    let baseURl = URL(string: "https://calorie-tracker-5526f.firebaseio.com/")!
    
    func createCalorie( calories: Int) -> Entry {
        let entry = Entry(calories: calories)
        save()
        return entry
    }
    
    func save(){
        moc.perform {
            do {
                try moc.save()
            }catch{
                NSLog("Error occured while trying to save")
                moc.reset()
            }
        }
    }
}

