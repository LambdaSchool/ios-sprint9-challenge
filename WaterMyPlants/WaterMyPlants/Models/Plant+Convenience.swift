//
//  Plant+Convenience.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/17/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    var plantRepresentation: PlantRepresentation? {
        guard let id = id,
            let plantName = plantName,
            let species = species else { return nil }
        let idInt = Int(id) ?? 0
        return PlantRepresentation(id: idInt, plantName: plantName, species: species, h2oFrequency: h2oFrequency)
        
    }
    
    @discardableResult convenience init(id: String = UUID().uuidString, name: String, species: String, image: String?, frequency: Double = 1.0, isWatered: Bool? = false, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.plantName = plantName
        self.species = species
        self.image = image
        self.h2oFrequency = frequency
        self.isWatered = isWatered ?? false
        
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(id: plantRepresentation.idString,
                  name: plantRepresentation.plantName,
                  species: plantRepresentation.species,
                  image: nil,
                  frequency: plantRepresentation.h2oFrequency,
                  isWatered: nil,
                  context: context)
    }
}
