//
//  DateFormatter.swift
//  CalorieTracker
//
//  Created by Ciara Beitel on 10/18/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation

extension Date {
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let currentDate = dateFormatter.string(from: Date())
        return currentDate
    }
}
