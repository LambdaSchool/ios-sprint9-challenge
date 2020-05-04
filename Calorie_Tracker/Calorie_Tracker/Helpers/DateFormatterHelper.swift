//
//  DateFormatterHelper.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit

extension TrackerTableViewCell {
      func formatter(currentDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
}
