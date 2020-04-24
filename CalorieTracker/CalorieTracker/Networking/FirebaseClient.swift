//
//  FirebaseClient.swift
//  Albums
//
//  Created by Shawn Gee on 4/6/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

private let baseURL = URL(string: "https://calorietracker-shawngee.firebaseio.com/")!

class FirebaseClient {

    func getCalorieEntries(completion: @escaping (Result<[String: CalorieEntryRepresentation], NetworkError>) -> Void) {
        let request = URLRequest(url: baseURL.appendingPathExtension("json"))
        
        URLSession.shared.dataTask(with: request) { result in
            completion(CalorieEntryResultDecoder().decode(result))
        }.resume()
    }
    
    func putCalorieEntry(_ calorieEntry: CalorieEntryRepresentation, completion: @escaping (NetworkError?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent(calorieEntry.id).appendingPathExtension("json"))
        request.httpMethod = HTTPMethod.put

        do {
            request.httpBody = try JSONEncoder().encode(calorieEntry)
        } catch {
            completion(.encodingError(error))
            return
        }

        URLSession.shared.dataTask(with: request, errorHandler: completion).resume()
    }

    func deleteCalorieEntry(_ calorieEntry: CalorieEntryRepresentation, completion: @escaping (NetworkError?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent(calorieEntry.id).appendingPathExtension("json"))
        request.httpMethod = HTTPMethod.delete

        do {
            request.httpBody = try JSONEncoder().encode(calorieEntry)
        } catch {
            completion(.encodingError(error))
            return
        }

        URLSession.shared.dataTask(with: request, errorHandler: completion).resume()
    }
}
