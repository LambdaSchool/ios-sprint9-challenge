//
//  EntryRepresentation.swift
//  Calorie Tracker
//
//  Created by Ufuk Türközü on 27.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let calories: Int16
    let date: Date
}
