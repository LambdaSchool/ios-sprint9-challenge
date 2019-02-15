//
//  FirebaseManager.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation


class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    //Firebase
    private let firebaseURL = URL(string: "https://calorie-tracker-211cb.firebaseio.com/")!
    
    //Put new Calorie entry on FB
    func sendtoFB(entry: Calorie, _ completion: @escaping Completions = Empties)
    {
        var data: Data?
        
        do {
            data = try JSONEncoder().encode(entry.getEntry())
            
        } catch { showErrors(completion, "Couldn't encode entry: \(error)") }
        
        let putRequest = buildURLRequest([entry.id!.uuidString], "PUT", data)
        
        URLSession.shared.dataTask(with: putRequest) { (_, _, error) in
            
            if let error = error {
                
                self.showErrors(completion, "Error putting: \(error)")
                return
            }
            completion(nil)
            }.resume()
    }
    
    //Retrieve entry from FB
    func getFromFB(_ completion:@escaping Completions = Empties)
    {
        let moc = CoreDataStack.shared.container.newBackgroundContext()
        
        let getRequest = buildURLRequest([], "GET")
        
        URLSession.shared.dataTask(with: getRequest) { data, _, error in
            if let error = error {
                self.showErrors(completion, "Error fetching: \(error)")
            }
            
            guard let data = data else { self.showErrors(completion, "Couldn't fetch data."); return}
            
            do {
                let stubs = try JSONDecoder().decode([String: CalorieRep].self, from:data)
                
                for (_, stub) in stubs {
                    
                    try CalorieManager.shared.matchToRep(entryRep: stub, moc: moc)
                }
                try CoreDataStack.saveAfterMerging(moc:moc)
                completion(nil)
            } catch {
                self.showErrors(completion, "Couldn't decode data: \(error)")
            }
            }.resume()
    }
    
    //Create the URL Request with the entered httpMethod and add entries to the URL path
    func buildURLRequest(_ ids: [String], _ httpMethod: String, _ data:Data? = nil) -> URLRequest
    {
        var url = firebaseURL
        url.appendPathComponent("entries")
        
        for id in ids {
            url.appendPathComponent(id)
        }
        url.appendPathExtension("json")
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod
        req.httpBody = data
        return req
    }
    
    //Report Errors
    func showErrors(_ completion: @escaping Completions, _ error: String)
    {
        NSLog(error)
        completion(error)
    }
}
