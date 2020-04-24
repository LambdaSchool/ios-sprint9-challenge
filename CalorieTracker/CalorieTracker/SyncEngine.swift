//
//  SyncEngine.swift
//  
//
//  Created by Shawn Gee on 4/24/20.
//

import CoreData
import Foundation

class SyncEngine: NSObject {
    private lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        try? frc.performFetch()
        
        return frc
    }()
    
    private let firebaseClient = FirebaseClient()
    
    override init() {
        super.init()
        fetchCalorieEntries()
    }
    
    private func fetchCalorieEntries() {
        firebaseClient.fetchCalorieEntries { result in
            switch result {
            case .failure(let networkError):
                print(networkError)
            case .success(let representations):
                self.syncCalorieEntries(with: representations)
            }
        }
    }
    
    private func syncCalorieEntries(with representationsByID: [String: CalorieEntryRepresentation]) {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "identifier IN %@", Array(entryReps.keys))
         let context = CoreDataStack.shared.mainContext
         
         let existingEntries = try context.fetch(fetchRequest)
         var entriesToCreate = entryReps
         
         for entry in existingEntries {
             let id = entry.identifier
             guard let representation = entryReps[id] else { continue }
             update(entry, with: representation)
             entriesToCreate.removeValue(forKey: id)
         }
         
         for representation in entriesToCreate.values {
             Entry(representation)
         }
         
         saveToPersistentStore()
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
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            //tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
