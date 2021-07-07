//
//  FirebaseManager.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager
{
    static let shared = FirebaseManager()
    
    func fetchFromDatabase(completion: @escaping (CalorieRepresentation) -> ())
    {
        Database.database().reference().child("reports").observeSingleEvent(of: .childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                let calorie = CalorieRepresentation(dictionary: dictionary)
                completion(calorie)
            }
        }
    }
    
    func uploadToDatabase(id: String, calories: Int, date: Int, completion: @escaping (Error?) -> ())
    {
        let values = ["identifier": id, "calories": calories, "date": date] as [String: Any]
        
        Database.database().reference().child("reports").child(id).updateChildValues(values) { (error, ref) in
            
            if let error = error
            {
                NSLog("Error uploading to Firebase: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
}
