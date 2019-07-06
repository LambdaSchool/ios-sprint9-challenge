//
//  CalorieEntryRepresentation.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

// NOTE: I do not think I need this, unless i get to stretch and want to add Firebase to the situation, then I'll need it to compare Representation with CoreData.  So I wrote this just in case I get to the stretch

class CalorieEntryRepresentation: Codable {
    
    var calorie: Int16
    var timestamp: Date
    
}
