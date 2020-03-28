//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry: Persistable {
    convenience init?(
        calories: Int,
        context: PersistentContext,
        timestamp: Date = Date(),
        identifier: UUID = UUID()
    ) {
        guard let context = context as? NSManagedObjectContext
            else { return nil }
        self.init(context: context)
        
        self.calories = Int64(calories)
        self.timestamp = timestamp
        self.identifier = identifier
    }

    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.calendar = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
