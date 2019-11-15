//
//  CalorieTrackerController.swift
//  Calorie Tracker
//
//  Created by Jesse Ruiz on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
// swiftlint:disable all

import UIKit
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}



class CalorieTrackerController {
    
    let baseURL = URL(string: "https://calorietracker-e97b0.firebaseio.com/")!
    
    init() {
        fetchCalorieLogsFromServer()
    }
    
    func fetchCalorieLogsFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching logs: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from calorie log fetch data task")
                completion()
                return
            }
            
            do {
                let log = try JSONDecoder().decode([String : CalorieTrackerRepresentation].self, from: data).map({ $0.value })
                self.updateLogs(with: log)
            } catch {
                NSLog("Error decoding CalorieTrackerRepresentation: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateLogs(with representations: [CalorieTrackerRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var logsToCreate = representationsByID
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
                
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingLogs = try context.fetch(fetchRequest)
                
                for log in existingLogs {
                    
                    guard let identifier = log.identifier,
                        let representation = representationsByID[identifier] else { continue }
                    
                    log.date = representation.date
                    log.calorie = representation.calorie
                    
                    logsToCreate.removeValue(forKey: identifier)
                }
                
                for representation in logsToCreate.values {
                    CalorieTracker(calorieTrackerRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching logs from persistent store: \(error)")
            }
        }
    }
    
    func put(log: CalorieTracker, completion: @escaping () -> Void = { }) {
        
        let identifier = log.identifier ?? UUID()
        log.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let calorieTrackerRepresentation = log.calorieTrackerRepresentation else {
            NSLog("Calorie Tracker Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(calorieTrackerRepresentation)
        } catch {
            NSLog("Error encoding calorie tracker representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTing task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func createLog(with calorie: Int, date: Date, context: NSManagedObjectContext) {
        let log = CalorieTracker(date: date, calorie: calorie, context: context)
        CoreDataStack.shared.save(context: context)
        put(log: log)
    }
}

