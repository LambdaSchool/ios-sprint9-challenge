
import Foundation
import CoreData

// Manager for getting data
class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    // How we interact with our data store
    let mainContext: NSManagedObjectContext
    
    init() {
        
        // Create a container, give it the name of data model file
        container = NSPersistentContainer(name: "Calorie Tracker")
        
        // Load the stores
        container.loadPersistentStores { (description, error) in
            if let e = error {
                fatalError("Couldn't load the data store: \(e)")
            }
        }
        
        mainContext = container.viewContext
        
        // Tell it to automatically merge the changes from parent
        mainContext.automaticallyMergesChangesFromParent = true
    }
    
    // Helper Method
    func saveTo(context: NSManagedObjectContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        if let error = saveError { throw error }
    }
}
