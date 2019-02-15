//
//  String+Extension.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

extension String {
    func convertToDouble() -> Double {
        let calorieTextConversionToIntDict: [Character: Int] = ["1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9]
        var caloriesIntArray: [Int] = []
        let stringToConvert = self
        for character in stringToConvert {
            if let number = calorieTextConversionToIntDict[character] {
                caloriesIntArray.append(number)
            }
        }
        var total: Int = 0
        for _ in caloriesIntArray {
            let last = caloriesIntArray.popLast()
            total *= 10
            total += last!
        }
        return Double(total)
    }
}
