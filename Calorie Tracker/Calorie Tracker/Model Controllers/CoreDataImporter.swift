//
//  CoreDataImporter.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData

class CoreDataImporter {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func sync(entries: [CalorieRepresentation], completion: @escaping (Error?) -> Void = {_ in }) {
        
        DispatchQueue.global().async {
            let entriesWithDate = entries.filter { $0.date != nil }
            let identifiersToFetch = entries.compactMap { $0.date}
            let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch,
                                                                          entriesWithDate))
            var entriesToCreate = representationByID
            
            let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date IN %@",
                                                 argumentArray: identifiersToFetch)
            
            self.context.perform {
                do {
                    let existingEntry = try self.context.fetch(fetchRequest)
                    
                    for entry in existingEntry{
                        guard let date = entry.date,
                            let representation = representationByID[date] else { continue }
                        self.update(entry: entry,
                                    with: representation)
                        entriesToCreate.removeValue(forKey: date)
                    }
                    for entry in entriesToCreate.values {
                        _ = Calories(calorieRepresentation: entry,
                                     context: self.context)
                    }
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func update(entry: Calories, with calorieRep: CalorieRepresentation) {
        entry.count = Int16(calorieRep.calories)
        entry.date = calorieRep.date
    }

}


