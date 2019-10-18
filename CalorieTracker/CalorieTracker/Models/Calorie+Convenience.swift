//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Ciara Beitel on 10/18/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(identifier: UUID = UUID(), intake: Int16, timestamp: Date = Date(), context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.intake = intake
        self.timestamp = timestamp
    }
}
