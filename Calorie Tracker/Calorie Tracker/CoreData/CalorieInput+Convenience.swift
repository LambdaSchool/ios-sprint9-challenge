
import Foundation
import CoreData

extension CalorieInput {

    convenience init(calories: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
        
    }
    
    var formattedTimeStamp: String? {
        guard let timestamp = timestamp else {
            return nil
        }

        return DateFormat.dateFormatter.string(from: timestamp)
    }
}
