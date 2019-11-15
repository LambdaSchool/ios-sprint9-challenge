//
//  UserController.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

class UserController {
    
    @discardableResult func create(user name: String, context: NSManagedObjectContext) -> User {
        let user = User(name: name, context: context)
        CoreDataStack.shared.save(context: context)
        return user
        
    }
    
    func delete(user: User, context: NSManagedObjectContext) {
        context.delete(user)
        CoreDataStack.shared.save(context: context)
    }
    
}
