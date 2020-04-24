//
//  SyncEngine.swift
//
//
//  Created by Shawn Gee on 4/24/20.
//

import CoreData
import Foundation

class SyncEngine: NSObject {
    private var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
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
    
    private func syncCalorieEntries(with entryReps: [String: CalorieEntryRepresentation]) throws {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", Array(entryReps.keys))
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let existingEntries = try context.fetch(fetchRequest)
        var entriesToCreate = entryReps
        
        for entry in existingEntries {
            let id = entry.id!
            guard let representation = entryReps[id] else { continue }
            update(entry, with: representation)
            entriesToCreate.removeValue(forKey: id)
        }
        
        for representation in entriesToCreate.values {
            CalorieEntry(representation, context: context)
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    // MARK: - Syncing
    
    private func update(_ entry: CalorieEntry, with representation: CalorieEntryRepresentation) {
        entry.calories = Int64(representation.calories)
        entry.date = Date(timeIntervalSinceReferenceDate: representation.date)
        entry.id = representation.id
    }
}

// MARK: - Fetched Results Controller Delegate

extension SyncEngine: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let calorieEntry = anObject as? CalorieEntry else { return }
        
        switch type {
        case .insert, .update:
            firebaseClient.putCalorieEntry(calorieEntry.representation) { error in
                if let error = error {
                    print(error)
                }
            }
        case .delete:
            firebaseClient.deleteCalorieEntry(calorieEntry.representation) { error in
                if let error = error {
                    print(error)
                }
            }
        default:
            break
        }
    }
}
