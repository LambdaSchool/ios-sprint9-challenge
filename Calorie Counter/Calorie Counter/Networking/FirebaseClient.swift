//
//  FirebaseClient.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/4/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit

private let baseURL = URL(string: "https://calorietracker-88d53.firebaseio.com/")!

class FirebaseClient {

    func getCalorieEntries(completion: @escaping (Result<[String: CalorieRepresentation], NetworkError>) -> Void) {
        let request = URLRequest(url: baseURL.appendingPathExtension("json"))
        
        URLSession.shared.dataTask(with: request) { result in
            completion(CalorieEntryResultDecoder().decode(result))
        }.resume()
    }
    
    func putCalorieEntry(_ calorieEntry: CalorieRepresentation, completion: @escaping (NetworkError?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent(calorieEntry.identifier ?? UUID().uuidString).appendingPathExtension("json"))
        request.httpMethod = HTTPMethod.put

        do {
            request.httpBody = try JSONEncoder().encode(calorieEntry)
        } catch {
            completion(.encodingError(error))
            return
        }

        URLSession.shared.dataTask(with: request, errorHandler: completion).resume()
    }

    func deleteCalorieEntry(_ calorieEntry: CalorieRepresentation, completion: @escaping (NetworkError?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent(calorieEntry.identifier ?? UUID().uuidString).appendingPathExtension("json"))
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
