//
//  CalorieIntake+Convenience.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init(id: String = UUID().uuidString, person: String, calorie: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.person = person
        self.calorie = calorie
        self.timestamp = timestamp
    }
    
}
