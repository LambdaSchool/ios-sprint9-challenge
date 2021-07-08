//
//  Entry+Encodable.swift
//  Calorie Tracker
//
//  Created by Iyin Raphael on 2/15/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: CodingKey {
        case calories
        case date
        case identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.calories, forKey: .calories)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.identifier, forKey: .identifier)
    }
    
//    var identity: UUID {
//        get {
//            return self.identifier!
//        } set {
//            self.identifier = newValue
//        }
//
//    }
}
