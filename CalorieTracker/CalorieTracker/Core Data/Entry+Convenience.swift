//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Dennis Rudolph on 12/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }

//    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let mood = Mood(rawValue: entryRepresentation.mood),
//              let identifierString = entryRepresentation.identifier,
//              let identifier = UUID(uuidString: identifierString) else {
//              return nil
//          }
//        self.init(name: entryRepresentation.title, description: entryRepresentation.bodyText, time: entryRepresentation.timestamp, identification: identifier, mood: mood, context: context)
//      }
//
//    var entryRepresentation: EntryRepresentation? {
//
//        guard let title = title,
//            let mood = mood else {
//                return nil
//        }
//
//        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, identifier: identifier?.uuidString ?? "", timestamp: timestamp ?? Date())
//    }
}
