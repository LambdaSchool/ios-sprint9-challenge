//
//  NetworkController.swift
//  Calorie Tracker
//  Created by Iyin Raphael on 2/15/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation


class NetworkController {
    
    private let baseURl = URL(string: "https://calorie-tracker-5526f.firebaseio.com/")!
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
    
    
}
