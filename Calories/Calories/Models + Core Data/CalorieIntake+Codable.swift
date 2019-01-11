//
//  CalorieIntake+Codable.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation

extension CalorieIntake: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case timestamp
    }
    
}
