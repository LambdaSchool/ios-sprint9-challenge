//
//  Calorie.swift
//  Calorie Tracker
//
//  Created by Juan M Mariscal on 6/12/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct Calorie {
    let calorie: String
    let date: Date
    
    init(calorie: String, date: Date = Date()){
        self.calorie = calorie
        self.date = date
    }
}
