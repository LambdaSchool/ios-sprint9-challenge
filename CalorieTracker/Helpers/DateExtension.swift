//
//  DateExtension.swift
//  CalorieTracker
//
//  Created by Dahna on 6/19/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

extension Date {
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm:ss a"
        return dateFormatter.string(from: self)
    }
}
