//
//  Entry+Conenience.swift
//  CALORIE-TRACKER
//
//  Created by Kelson Hartle on 6/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation


import CoreData

extension CalorieIntake {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
        let timeStamp = timeStamp,
        let numOfCalories = numOfCalories else { return nil }

        return EntryRepresentation(identifier: id, timeStamp: timeStamp, numOfCalories: numOfCalories)
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        
        self.init(context: context)
        self.numOfCalories = entryRepresentation.numOfCalories
        self.identifier = entryRepresentation.identifier
        self.timeStamp = entryRepresentation.timeStamp
        
    }
    

    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                        numOfCalories: String,
                                        timeStamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.numOfCalories = numOfCalories
        self.timeStamp = timeStamp
        
        
    }
}
