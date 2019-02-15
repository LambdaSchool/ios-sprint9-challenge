//
//  CalorieChart.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit
import CoreData

class CalorieManager {
    
    static let shared = CalorieManager()
    
    var chartData: [Double] = []
    
    func buildChartData() -> ChartSeries {
        
        for x in calories {
            
            chartData.append(x.amount)
        }
        
        let series = ChartSeries(chartData)
        
        return series
    }
    
    
    
    
    var calories: [Calorie] {
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        
        //Return an array of Calories or an empty array if it fails
        let results = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        
        return results //This will be what enters calories array.
    }
    
    //Core Data CRUD
    
    //Create a new Calorie entry
    func newEntry(amount: Double, date: Date, moc: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        moc.perform {
            
            let entry = Calorie(amount: amount, date: date)
            
            FirebaseManager.shared.sendtoFB(entry: entry)
            
            do { try moc.save()
                    
            } catch { NSLog("Failed to save while creating a new entry") }
            
            }
        }

    
    //Match data from FB to Calorie Representation
    func matchToRep(entryRep: CalorieRep, moc: NSManagedObjectContext) throws {
    
        var caughtError: Error?
        
        moc.perform {
            
            let req: NSFetchRequest<Calorie> = Calorie.fetchRequest()
    
            req.predicate = NSPredicate(format: "id = %@", entryRep.id as NSUUID)
            
            var entry: Calorie?
            
            do {
                
                entry = try moc.fetch(req).first //Find the first entry with that ID
            
            } catch {
    
                caughtError = error
            }
    
            if let foundEntry = entry { //If there's an entry with that ID...
    
                foundEntry.assignEntry(tempEntry: entryRep) //Match it up.
    
            } else { _ = Calorie(amount: entryRep.amount, date: entryRep.date, id: entryRep.id, context: moc) //Else create a new entry
    
            }
    
        }
    
        if let caughtError = caughtError {
    
            throw caughtError
    
        }
    }//End of Matching Func
    
    
    //Delete Calorie Entry
    func deleteEntry(entry: Calorie, _ completion:@escaping Completions = Empties) {
        let stub = entry.getEntry() //Get a reference of the entry on Firebase
        
        guard let moc = entry.managedObjectContext else { return }
        
        moc.performAndWait {
            moc.delete(entry) //Delete the entry
            
            do {
                try moc.save() //Save the change
                
            } catch {
                
                showErrors(completion, "Unable to save moc")
                return
            }
        }
        
        let deleteRequest = FirebaseManager.shared.buildURLRequest([stub.id.uuidString], "DELETE")
        
        URLSession.shared.dataTask(with: deleteRequest) { (_, _, error) in
            if let error = error {
                self.showErrors(completion, "Error deleting: \(error)")
                return
            }
            
            completion(nil)
            
            }.resume()
    }
    
    //Report Errors
    func showErrors(_ completion: @escaping Completions, _ error: String) {
        NSLog(error)
        completion(error)
    }
    
}//End of class

//Type Alias for pretty completion handling
typealias Completions = (String?) -> Void
let Empties: Completions = {_ in}


