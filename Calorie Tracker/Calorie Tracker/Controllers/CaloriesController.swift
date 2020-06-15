import Foundation
import CoreData

class CaloriesController {
    
    
    // MARK: - Functions
    
    // Saves to changes on moc to Persistent Store
    private func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}
