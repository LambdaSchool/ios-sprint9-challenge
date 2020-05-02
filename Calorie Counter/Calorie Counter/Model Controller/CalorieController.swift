//
//  CalorieController.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart


class CalorieController {
    func addEntry(entry: Calorie, completion: @escaping () -> Void = {}) {
        try? CoreDataStack.shared.save()
        
        //TODO Notification observers will go here
        
    }
}
