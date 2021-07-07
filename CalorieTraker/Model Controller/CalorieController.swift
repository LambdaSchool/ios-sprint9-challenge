//
//  CalorieController.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreData



class CalorieController {
    
    init() {
       // print("about to fetch")
        fetchCaloriesFromServer()
    }
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://calorietraker.firebaseio.com/")!
    let moc = CoreDataStack.shared.mainContext
    let backgroundMoc = CoreDataStack.shared.backgroundContext
    var calorieSeries: [Double] = []
    
    // MARK: - Persistent Coordinator
    
    func saveToPersistentStore() {
        moc.performAndWait {
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    func saveToBackgroundMoc() {
        self.backgroundMoc.performAndWait {
            do {
                try self.backgroundMoc.save()
            } catch {
                NSLog("Error saving background context: \(error)")
            }
        }
    }
    
    func createCalorie(with amount: Double) {
        let calorie = Calorie(amount: amount)
        
        calorieSeries.append(amount)
        print(calorieSeries)
        putToServer(calorie: calorie)
        saveToPersistentStore()
    }
    
    func putToServer(calorie: Calorie, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = calorie.identifier ?? UUID().uuidString
        
        let urlPlusID = baseURL.appendingPathComponent(identifier)
        let urlPlusJSON = urlPlusID.appendingPathExtension("json")
        
        var request = URLRequest(url: urlPlusJSON)
        request.httpMethod = "PUT"
        
        do {
            let encoder = JSONEncoder()
            let calorieJSON = try encoder.encode(calorie)
            request.httpBody = calorieJSON
        } catch {
            NSLog("Error encoding error: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error putting entry tot the server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func update(calorie: Calorie, calorieRep: CalorieRepresentation) {
        calorie.identifier = calorieRep.identifier
        calorie.timestamp = calorieRep.timestamp
        calorie.amount = calorieRep.amount
    }
    
    func delete(calorie: Calorie) {
        moc.delete(calorie)
       // deleteFromServer(calorie: calorie)
        saveToPersistentStore()
    }
    

    func fetchSingleCalorieFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Calorie? {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var calorie: Calorie?
        context.performAndWait {
            do {
                calorie = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching single entry from Persistent Store")
            }
        }
        return calorie
    }
    
    func updatePersistentStoreWithServer(_ calorieRepresentations: [CalorieRepresentation],
                                         context: NSManagedObjectContext) {
        context.performAndWait {
            for cal in calorieRepresentations {
                let calorie = self.fetchSingleCalorieFromPersistentStore(identifier: cal.identifier,
                                                                     context: context)
                
                if let calorie = calorie, calorie != cal {
                    self.update(calorie: calorie, calorieRep: cal)
                } else if calorie == nil {
                    Calorie(calorieRep: cal, context: context)
                }
            }
        }
    }
    
    func fetchCaloriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let urlPlusJSON = baseURL.appendingPathExtension("json")
        print(urlPlusJSON)
        URLSession.shared.dataTask(with: urlPlusJSON) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else  {
                NSLog("No data returned from server")
                completion(NSError())
                return
            }
            
            do {
                print("about to decode")
                let decoder = JSONDecoder()
                let calorieRepDict = try decoder.decode([String: CalorieRepresentation].self, from: data)
                let calorieRepresentations = calorieRepDict.map{ $0.value }
                
                
                self.updatePersistentStoreWithServer(calorieRepresentations, context: self.backgroundMoc)
                self.saveToBackgroundMoc()
                completion(nil)
            } catch {
                NSLog("Error decoding entry representation: \(error)")
                completion(error)
            }
            
            }.resume()
    }
    
}
