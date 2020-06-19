//
//  Alert.swift
//  CalorieTracker
//
//  Created by Joe Veverka on 6/19/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

enum Alert {
    static func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func saveEntry(vc: UIViewController) {
        let alert = UIAlertController(title: "Calorie Entry", message: "Enter the amount of calories you want to track", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter Calorie Amount!"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
            guard let text = alert?.textFields?[0].text,
                let calAmount = Int(text)
                else { return }
            _ = CalorieEntry(calories: calAmount, date: Date())
            do {
                try CoreDataStack.shared.save()
            } catch {
                print("Error Saving context: ", error)
            }
            NotificationCenter.default.post(name: .postedEntry, object: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(alert, animated: true)
    }
}
