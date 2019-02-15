//
//  CalorieConvenience.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation
import CoreData
extension Calorie { //Extending the Calorie entity in the data model.
    
    convenience init(
        amount: Double,
        date: Date,
        id: UUID? = nil,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context) //Setting context to my coredata main context
        self.amount = amount //Attribute from the Calorie Entity
        self.date = date //Attribute from the Calorie Entity
        self.id = id ?? UUID() //If there is no identifier, make one

    }
    
    //This returns an instance of the Calorie with all properties unwrapped
    func getEntry() -> CalorieRep {
        return CalorieRep(amount: amount, date: date!, id: id!) }
    
    //This assigns an instance of the Calorie Representation to the Core Data Model
    func assignEntry(tempEntry: CalorieRep) {
        
        self.amount = tempEntry.amount
        self.date = tempEntry.date
        self.id = tempEntry.id
        
        }
        
}
