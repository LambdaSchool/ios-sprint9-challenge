//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/18/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let id: Int
    let plantName: String
    let species: String
    let h2oFrequency: Double
    var idString: String {
        return String(id)
    }
}
