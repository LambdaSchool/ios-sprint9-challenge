
import Foundation
import CoreData

extension CalorieInput {

    convenience init(calories: Int16, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
    
    convenience init?(calorieInputRepresentation: CalorieInputRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(calories: calorieInputRepresentation.calories, timestamp: calorieInputRepresentation.timestamp, identifier: calorieInputRepresentation.identifier, context: context)
    }
    
    var formattedTimeStamp: String? {
        guard let timestamp = timestamp else {
            return nil
        }

        return DateFormat.dateFormatter.string(from: timestamp)
    }
}
