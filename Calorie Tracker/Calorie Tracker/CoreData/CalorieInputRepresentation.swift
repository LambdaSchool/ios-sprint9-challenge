
import Foundation

struct CalorieInputRepresentation: Decodable, Equatable {
    
    let calories: Int16
    let timestamp: Date
    let identifier: String
}

func == (lhs: CalorieInputRepresentation, rhs: CalorieInput) -> Bool {
    return lhs.calories == rhs.calories && lhs.timestamp == rhs.timestamp && lhs.identifier == rhs.identifier
}

func == (lhs: CalorieInput, rhs: CalorieInputRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: CalorieInputRepresentation, rhs: CalorieInput) -> Bool {
    return !(rhs == lhs)
}
