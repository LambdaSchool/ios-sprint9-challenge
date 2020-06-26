//
//  UserRepresentation.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/18/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let id: Int?
    let username: String
    let password: String?
    let phoneNumber: String?    
}
