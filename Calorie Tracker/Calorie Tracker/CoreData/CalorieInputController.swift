
import Foundation
import CoreData


class CalorieInputController {
    
    var caloriesInput: [CalorieInput] {
        
        // Allows any changes to the persistent store to become imediately visible when accessing the array (i.e. in the table view showing a list of calorie inputs)
        return loadFromPersistentStore()
    }
    
    // Saves core data stack's mainContext
    // This will bundle the changes in the context, pass them to the persistent store coordinator, who will then put those changes in the persistent store.
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            fatalError("Error saving to core data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [CalorieInput] {
        var caloriesInput: [CalorieInput] {
            do {
                let fetchRequest: NSFetchRequest<CalorieInput> = CalorieInput.fetchRequest()
                let result = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                return result
            } catch {
                fatalError("Can't fetch Data \(error)")
            }
        }
        return caloriesInput
    }
    
    
    func createInput(calories: Int16, timestamp: Date) {
        
        // Initialize an Entry object
        let newInput = CalorieInput(context: CoreDataStack.shared.mainContext)
        newInput.calories = calories
        newInput.timestamp = timestamp
        
        // Save to the persistent store
        saveToPersistentStore()
        
    }
    
    // Paremeters: Input to be updated & calories - not allowing for manual time update
    func updateInput(calorieInput: CalorieInput, calories: Int16) {
        
        // Change the # of calories of the Input to the new value passed in as parameters
        calorieInput.calories = calories
 
        // Update the entry's timestamp to the current time
        calorieInput.timestamp = Date.init()
        
        // Save changes to the persistent store
        saveToPersistentStore()
        
    }
    
    
    func deleteInput(calorieInput: CalorieInput) {
        
        CoreDataStack.shared.mainContext.delete(calorieInput)
        
        // Save this deletion to the persistent store
        saveToPersistentStore()
    }
    
}
