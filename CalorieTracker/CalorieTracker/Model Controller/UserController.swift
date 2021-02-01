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

class UserController {
    
//    init() {
//
//    }

    typealias CompletionHandler  = (Result<Bool, NetworkError>) -> Void

    func fetchUsersFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
    }

    
}
