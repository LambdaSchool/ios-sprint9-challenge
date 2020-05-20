//
//  Calorie+Conv.swift
//  Core Data 1
//
//  Created by Sergey Osipyan on 2/15/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    convenience init(identifier: String = UUID().uuidString, data: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.data = data
        self.timestamp = timeFormatted
    }
    var timeFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let timeAndDate = dateFormatter.string(from: Date())
        return timeAndDate
        
    }
}
