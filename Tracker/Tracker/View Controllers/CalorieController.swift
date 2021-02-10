import Foundation
import CoreData

class CalorieController {

  //  var calrories : [Calorie] = []

  func createNewItem(amount: Int,
                     date: Date = Date(),
                     into context: NSManagedObjectContext = CoreDataStack.shared.mainContext
  ) {

    Calorie(calories: amount, timestamp: date, context: context)

    saveToPersistentStoreAndUpdateGraph()
  }


  private func saveToPersistentStoreAndUpdateGraph() {
    do {
      try CoreDataStack.shared.mainContext.save()
      NotificationCenter.default.post(name: .shouldUpdateGraph, object: self)
    } catch {
      NSLog("Error saving managed error context: \(error)")
    }
  }

  func deleteCalorie(calorie: Calorie) {
    CoreDataStack.shared.mainContext.delete(calorie)

    saveToPersistentStoreAndUpdateGraph()
  }
}


