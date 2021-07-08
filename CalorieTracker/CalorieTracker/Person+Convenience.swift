//
//  Person+Convenience.swift
//  CalorieTracker
//
//  Created by Sean Hendrix on 1/11/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

extension Person {
    convenience init (name: String, id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = name
        self.id = id
    }
}
