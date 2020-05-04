//
//  FirebaseSyncEngine.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/4/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData

class FireBaseSyncEngine: NSObject {
    private var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        try? frc.performFetch()
        return frc
        }()
    
    
    private let firebaseClient = FirebaseClient()
    
    
    override init() {
        super.init()
        fetchCalorieEntries()
        fetchedResultsController.delegate = self
    }
    
    private func fetchCalorieEntries() {
        firebaseClient.getCalorieEntries { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let representations):
                try? self.syncCalorieEntries(with: representations)
            }
        }
    }
    
    private func syncCalorieEntries(with entryRepresentations: [String: CalorieRepresentation]) throws {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", Array(entryRepresentations.keys))
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let existingEntries = try context.fetch(fetchRequest)
        var entriesToCreate = entryRepresentations
        
        for entry in existingEntries {
            let identifier = entry.identifier!
            guard let representation = entryRepresentations[identifier] else { continue }
            update(entry, with: representation)
            entriesToCreate.removeValue(forKey: identifier)
        }
        
        for representation in entriesToCreate.values {
            Calorie(representation, context: context)
        }
        try CoreDataStack.shared.save(context: context)
        NotificationCenter.default.post(name: .newEntryAdded, object: nil)
    }
    
    // Syncing
    private func update(_ entry: Calorie, with representation: CalorieRepresentation) {
        entry.calories = Int16(representation.calories)
        entry.date = Date(timeIntervalSinceReferenceDate: representation.date)
        entry.identifier = representation.identifier
    }
}

// MARK: - Fetched Results Controller Delegate
extension FireBaseSyncEngine: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let calorieEntry = anObject as? Calorie else { return }
        
        switch type {
        case .insert, .update:
            firebaseClient.putCalorieEntry(calorieEntry.calorieRepresentation!) { error in
                if let error = error {
                    print(error)
                }
            }
        case .delete:
            firebaseClient.deleteCalorieEntry(calorieEntry.calorieRepresentation!) { error in
                if let error = error {
                    print(error)
                }
            }
        default:
            break
        }
    }
}
