//
//  CaloriesRepresentation.swift
//  Calorie Tracker
//
//  Created by Ilgar Ilyasov on 10/26/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

struct CaloriesRepresentation {
    let amount: Int
    let date: Date
    
    init(amount: Int, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}
