//
// swiftlint:disable all
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Jerry haaser on 11/15/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }
    // lazy doesn't initialize upone class initialization, it is only called when needed
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Core sata was unable to load persistence stores: \(error)")
            }
        })
        return container
    }()
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }    
    func save() {
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("error saving context: \(error)")
                context.reset()
            }
        }
    }
}
