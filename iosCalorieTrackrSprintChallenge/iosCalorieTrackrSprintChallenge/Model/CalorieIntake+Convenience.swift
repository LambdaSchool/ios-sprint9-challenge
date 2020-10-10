//
//  CalorieIntake+Convenience.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import Foundation
import CoreData

extension CalorieIntake {
    var calorieIntakeRepresentation: CalorieIntakeRepresentation? {
        guard let calories = calories,
              let timestamp = timestamp
        else { return nil }
        
        return CalorieIntakeRepresentation(calories: calories, timestamp: timestamp)
    }
}
