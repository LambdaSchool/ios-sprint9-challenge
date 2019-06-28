//
//  CoreData.swift
//  CalorieSprint
//
//  Created by Ryan Murphy on 6/28/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Calorie")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
