
import Foundation

class CalorieInput {
    
    let calories: Int
    let timestamp: Date
    
    init(calories: Int, timestamp: Date = Date()) {
        self.calories = calories
        self.timestamp = timestamp
    }
}
