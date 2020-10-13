//
//  UserController.swift
//  CalorieTracker
//
//  Created by Sammy Alvarado on 10/12/20.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noCalories
    case noTime
    case noId
    case noData
    case noDecode
    case noEncode
    case noRep
    case noUser
}

let baseURL = URL(string: "https://journal-core-data-day3.firebaseio.com/")!

class UserController {
    
//    init() {
//        
//    }
//    
//    typealias CompletionHandler  = (Result<Bool, NetworkError>) -> Void
//    
//    func fetchUsersFromServer(completion: @escaping CompletionHandler = { _ in }) {
//        let requestURL = baseURL.appendingPathExtension("json")
//        
//        let user = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
//            if let error = error {
//                print("Error fetching tasks: \(error)")
//                completion(.failure(.noUser))
//                return
//            }
//            
//            guard let data = data else {
//                print("No data was able to be return")
//                completion(.failure(.noData))
//                return
//            }
//            
//            do {
//                let userRepresentations = Array(try JSONDecoder().decode([String: UserRepresentation].self, from: data).values)
//                try self.updateUser(with: userRepresentations)
//            } catch {
//                
//            }
//        }
//    }
//    
//    
//    func sendUserInfoToServer(user: Users, completion: @escaping CompletionHandler = { _ in }) {
//        guard let uuid = user.time else {
//            completion(.failure(.noId))
//            return
//        }
//
//        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "PUT"
//
//        do {
//            guard let representation = user.userRepresentation else {
//                completion(.failure(.noRep))
//                return
//            }
//
//            request.httpBody = try JSONEncoder().encode(representation)
//        } catch {
//            print("Error encoding user data \(user): \(error)")
//            completion(.failure(.noEncode))
//            return
//        }
//
//        let user = URLSession.shared.dataTask(with: request) { (_, _, error) in
//            if let error = error {
//                print("Error PUTting task to server: \(error)")
//                completion(.failure(.otherError))
//                return
//            }
//
//            completion(.success(true))
//        }
//
//        user.resume
//    }
    
}
