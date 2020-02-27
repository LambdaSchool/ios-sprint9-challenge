//
//  TrackRep.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_201 on 2/24/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation

struct TrackRepresentation {
    struct Calorie: Codable {
        let caloriesCount: Int
        let date: Date
    }
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    let id: String
    var caloriesList: [Calorie] = []
}
