//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class CalorieDataController {
    private(set) var calorieDatas: [CalorieData] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD Methods
    func createCalorieData(calories: Double, person: Person, timestamp: Date = Date(), id: String = UUID().uuidString) {
        _ = CalorieData(calories: calories, person: person, timestamp: timestamp, id: id)
        
        saveToPersistentStore()
    }
    
    func createPerson(name: String, id: String = UUID().uuidString) -> Person {
        let person = Person(name: name, id: id)
        
        saveToPersistentStore()
        return person
    }
    
    // MARK: - Persistence
    private func saveToPersistentStore() {
        let mainContext = CoreDataStack.shared.mainContext
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch {
                NSLog("Error saving main object context: \(error)")
            }
        }
    }
    
    private func loadFromPersistentStore() {
        let fetchRequest: NSFetchRequest<CalorieData> = CalorieData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            calorieDatas = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Calories to main object context: \(error)")
        }
    }
    
    func fetchCalories(for person: Person) -> [CalorieData] {
        let fetchRequest: NSFetchRequest<CalorieData> = CalorieData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let predicate = NSPredicate(format: "person = %@", person)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        do {
            let calorieDatas = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return calorieDatas
        } catch {
            NSLog("Error fetching Calories to main object context: \(error)")
            return []
        }
    }
    
    func fetchPeople() -> [Person] {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let people = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return people
        } catch {
            NSLog("Error fetching People to main object context: \(error)")
            return []
        }
    }
    
    func fetchData() {
        loadFromPersistentStore()
    }
}
