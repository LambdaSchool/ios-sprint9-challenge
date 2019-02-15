//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    private init() {
        
        container = NSPersistentContainer(name: "Calorie_Tracker")
        container.loadPersistentStores { (description, error) in
            if let cdLoadError = error { fatalError("Couldn't load from Core Data container: \(cdLoadError)") }
        } //End of container
        
        mainContext = container.viewContext

    } // End of Init
    
    //Save after merging changes
    static func saveAfterMerging(moc: NSManagedObjectContext) throws {
        
        var theError: Error? //Allow for an error
        
        moc.performAndWait {
            
            do {
                try moc.save() //Attempt to save
                
            } catch {
                
                theError = error //If there's an error, assign it for use
            }
        } //End of Perform and Wait
        
        if let SAMerror = theError { //Unwrap the error
            throw SAMerror //Report the error
        }
    }
    
}//End of CoreDataStack
