import CoreData

class CaloriesController {
    
    
    // MARK: - Properties
    
    fileprivate let moc = CoreDataStack.shared.mainContext
    
    
    // MARK: - Functions
    
    // Saves to changes on moc to Persistent Store
    private func saveToPersistentStore() throws {
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving deleted task: \(error)")
        }
    }
    
    // Deletes item from Persistent Store
    private func deleteFromPersistentStore(_ item: Calories) {
        moc.delete(item)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving deleted task: \(error)")
        }
    }
}
