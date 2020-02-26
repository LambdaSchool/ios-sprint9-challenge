//
//  CalorieEntries.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

struct CalorieEntries: Codable {
    var calorie: Int16
    var timestamp: Date
}
