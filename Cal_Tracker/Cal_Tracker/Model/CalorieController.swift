//
//  CalorieController.swift
//  Cal_Tracker
//
//  Created by Lydia Zhang on 4/24/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func create(calorie: Int16) {
        let _ = Calorie(calorie: calorie)
        try! CoreDataStack.shared.save()

    }
}
