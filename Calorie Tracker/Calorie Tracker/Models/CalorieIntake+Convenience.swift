//
//  CalorieIntake+Convenience.swift
//  Calorie Tracker
//
//  Created by Lisa Sampson on 9/21/18.
//  Copyright © 2018 Lisa M Sampson. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init(identifier: String = UUID().uuidString, calorie: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calorie = calorie
        self.timestamp = timestamp
    }
}
