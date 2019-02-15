//
//  EntryReperesentation.swift
//  Calorie Tracker
//
//  Created by Iyin Raphael on 2/15/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

struct EntryReperesentation: Decodable {
    
    var date: Date
    var calories: Int32
    var identifier: UUID
    
}

func == (lhs: EntryReperesentation, rhs: Entry) -> Bool {
    return  lhs.date == rhs.date &&
            lhs.calories == rhs.calories &&
            lhs.identifier == rhs.identifier
}

func == (rhs: Entry, lhs: EntryReperesentation) -> Bool {
    return  rhs == lhs
}

func != (lhs: EntryReperesentation, rhs: Entry) -> Bool {
    return lhs != rhs
}

func != (rhs: Entry, lhs: EntryReperesentation) -> Bool {
    return rhs != lhs
}
