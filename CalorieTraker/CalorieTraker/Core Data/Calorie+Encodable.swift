//
//  Calorie+Encodable.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

extension Calorie: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(amount, forKey: .amount)
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
        case timestamp
    }
}

