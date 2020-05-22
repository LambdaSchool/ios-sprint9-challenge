//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Hunter Oppel on 5/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let didCreateNewCalorie = NSNotification.Name("didCreateNewCalorie")
}

class CalorieController {
    func createCalorie(amount: String) {
        Calorie(amount: amount)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        NotificationCenter.default.post(name: .didCreateNewCalorie, object: self)
    }
}
