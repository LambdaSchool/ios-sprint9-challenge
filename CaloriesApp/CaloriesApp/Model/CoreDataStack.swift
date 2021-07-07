//
//  CoreDataStack.swift
//  CaloriesApp
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    //singleton
    static let shared = CoreDataStack()
    
    private init() {}

    lazy var container: NSPersistentContainer = {
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
    
        let container = NSPersistentContainer(name: appName)
       
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
