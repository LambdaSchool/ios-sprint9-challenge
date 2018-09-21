//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Andrew Dhan on 9/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation

extension Entry {
    convenience init(date: Date = Date(), calories: Int) {
        self.init()
        self.date = date
        self.calories = Int32(calories)
    }
}
