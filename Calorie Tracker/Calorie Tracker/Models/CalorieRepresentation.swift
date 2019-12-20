//
//  CalorieRepresentation.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

struct CalorieRepresentation: Codable {
    let calorie: String
    let date: Date
    let id: UUID
}
