//
//  Intake+Convenience.swift
//  CalorieTracker
//
//  Created by Cora Jacobson on 10/10/20.
//

import Foundation
import CoreData

extension Intake {
    
    var intakeRepresentation: IntakeRepresentation? {
        guard let timestamp = timestamp else { return nil }
        return IntakeRepresentation(calories: Int(calories), timestamp: timestamp, identifier: identifier?.uuidString ?? "")
    }
    
    @discardableResult convenience init(calories: Int,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(intakeRepresentation: IntakeRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: intakeRepresentation.identifier) else { return nil }
        self.init(calories: intakeRepresentation.calories,
                  timestamp: intakeRepresentation.timestamp,
                  identifier: identifier,
                  context: context)
    }
    
}
