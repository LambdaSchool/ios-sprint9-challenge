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
    
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://calorietraker.firebaseio.com/")!
    let moc = CoreDataStack.shared.mainContext
    let backgroundMoc = CoreDataStack.shared.backgroundContext
    
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
    
    func createCalorie(with amount: Int64) {
        let calorie = Calorie(amount: amount)
        
       // putToServer(calorie: calorie)
        saveToPersistentStore()
    }
    
   /* func putToServer(calorie: Calorie, completion: @escaping (Error?) -> Void = { _ in }) {
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
    }*/
    
    
}
