//
//  CalorieRepresentation.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct CalorieRepresentation
{
    let date: Date
    let calories: Int
    let identifier: String
    
    init(dictionary: [String: Any])
    {
        let dateNumber = dictionary["date"] as! NSNumber
        self.date = Date(timeIntervalSince1970: dateNumber.doubleValue)
        self.calories = dictionary["calories"] as! Int
        self.identifier = dictionary["identifier"] as! String
    }
}
