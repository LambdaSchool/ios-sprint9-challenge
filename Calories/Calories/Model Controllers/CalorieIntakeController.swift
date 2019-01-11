//
//  CalorieIntakeController.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData


class CalorieIntakeController {
    
    static let shared = CalorieIntakeController()
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK:- Types & properties
    
    let baseUrl = URL(string: "https://lambda-calorie-tracker.firebaseio.com/")!
    
    
    // MARK:- Create new calorie intakes and delete them
    
    func newCalorieIntake(name: String, amount: Double) {
        let intake = CalorieIntake(name: name, amount: amount)
        
        put(calorieIntake: intake)
        savePersistentStore()
        
        NotificationCenter.default.post(name: .calorieIntakeValuesChanged, object: nil)
    }
    
    func delete(calorieIntake: CalorieIntake) {
        CoreDataStack.shared.mainContext.delete(calorieIntake)
        
        deleteCalorieIntakeFromServer(calorieIntake)
        savePersistentStore()
        
        NotificationCenter.default.post(name: .calorieIntakeValuesChanged, object: nil)
    }
    
}


// MARK:- Networking

extension CalorieIntakeController {
    
    
    // PUT intake in Firebase
    private func put(calorieIntake: CalorieIntake, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = calorieIntake.identifier else {
            NSLog("Calorie intake identifer is nil")
            completion(NSError())
            return
        }
        
        let requestUrl = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.put
        
        do {
            request.httpBody = try JSONEncoder().encode(calorieIntake)
        } catch {
            NSLog("Error encoding calorie intake: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing calorie intake to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    
    // DELETE intake from Firebase
    private func deleteCalorieIntakeFromServer(_ calorieIntake: CalorieIntake, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = calorieIntake.identifier else {
            NSLog("Calorie intake identifer is nil")
            completion(NSError())
            return
        }
        
        let requestUrl = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.delete
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing calorie intake from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    
    // Fetch calorie intakes from server
    func fetchCalorieIntakesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestUrl = baseUrl.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching calorie amounts from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            let moc = CoreDataStack.shared.mainContext
            
            do {
                let intakeReps = try JSONDecoder().decode([String: CalorieIntakeRepresentation].self, from: data).map({ $0.value })
                self.updateCalorieIntakes(with: intakeReps, in: moc)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
                return
            }
            
            moc.perform {
                do {
                    try moc.save()
                    completion(nil)
                } catch {
                    NSLog("Error saving context: \(error)")
                    completion(error)
                }
            }
        }.resume()
    }
    
    
    // Fetch a single intake from persistent store
    private func fetchSingleCalorieIntakeFromPersistentStore(with identifier: String?, in context: NSManagedObjectContext) -> CalorieIntake? {
        
        guard let identifier = identifier else { return nil }
        
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: CalorieIntake? = nil
        do {
            result = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching single calorie intake: \(error)")
        }
        
        return result
    }
    
    
    // Intake synchronization
    private func updateCalorieIntakes(with representations: [CalorieIntakeRepresentation], in context: NSManagedObjectContext) {
        
        context.performAndWait {
            for intakeRep in representations {
                
                let identifier = intakeRep.identifier
                let intake = self.fetchSingleCalorieIntakeFromPersistentStore(with: identifier, in: context)
                
                if intake == nil {
                    _ = CalorieIntake(calorieIntakeRepresentation: intakeRep, context: context)
                    savePersistentStore()
                }
            }
        }
    }
    
    
    // Save persistent store
    private func savePersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
