//
//  NetworkController.swift
//  Calorie Tracker
//  Created by Iyin Raphael on 2/15/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData


extension EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in }) {
        
        let url = baseURl
            .appendingPathComponent(entry.identifier?.uuidString ?? UUID().uuidString)
            .appendingPathExtension("json")
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "PUT"
        
        do{
            let jsonEncoder = JSONEncoder()
            requestURL.httpBody = try jsonEncoder.encode(entry)
        } catch {
            NSLog("Error encoding Entry Data")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: requestURL) { (_, _, error) in
            if let error = error {
                NSLog("Error Putting data to Database")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
    
    
    func fetchSingleEntryFromPersisitenceStore(identifier: UUID) -> Entry?{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        return (try? moc.fetch(fetchRequest))?.first
    }
    
    func fetchEntriesFromServer(completionHandler: @escaping CompletionHandler = {_ in}) {
        let url = baseURl.appendingPathExtension("json")
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                NSLog("Data not found on database")
                completionHandler(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error fetching data task: \(error)")
                completionHandler(error)
                return
            }
            
            do{
                let entryRepresetationDict = try JSONDecoder().decode([String: EntryReperesentation].self, from: data)
                let entryRepresentations = Array(entryRepresetationDict.values)
                print(entryRepresentations)
                for entryRep in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersisitenceStore(identifier: entryRep.identifier){
                        self.update(entry: entry, entryRepresentation: entryRep)
                    }else {
                        let _ = Entry(entryRepresentation: entryRep)
                    }
                }
                self.save()
                completionHandler(nil)
            }catch{
                NSLog("Error occured trying to retrieve data from dataBase \(error)")
                completionHandler(error)
                return
            }
            }.resume()
    }
    
    func update(entry: Entry, entryRepresentation: EntryReperesentation){
        entry.calories = entryRepresentation.calories
        entry.date = entryRepresentation.date
        entry.identifier = entryRepresentation.identifier
        put(entry: entry)
    }
    
}
