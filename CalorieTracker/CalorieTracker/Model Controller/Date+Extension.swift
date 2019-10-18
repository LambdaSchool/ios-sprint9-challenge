//
//  Date+Extension.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_214 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

extension Date {
    func formatted () -> String {
        var date: String = ""
        let formatter = ISO8601DateFormatter()
        date = formatter.string(from: self)
        return date
    }
}
