//
//  User+Convenience.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/17/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let username = username else { return nil }
        return UserRepresentation(id: Int(id ?? ""),
        username: username,
        password: password,
        phoneNumber: phoneNumber)
        
    }
    
    @discardableResult convenience init(id: String?, username: String, phoneNumber: String, password: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.username = username
        self.phoneNumber = phoneNumber
        self.password = password
        
    }
}
