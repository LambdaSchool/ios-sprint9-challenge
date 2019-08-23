//
//  CalorieCountRepresentation.swift
//  CalorieTracker
//
//  Created by Kat Milton on 8/23/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation

struct CalorieCountRepresentation: Codable, Equatable {
    var intakeNumber: String?
    var date: Date?
}

func == (lhs: CalorieCountRepresentation, rhs: CalorieCount) -> Bool {
    return lhs.date == rhs.date && lhs.intakeNumber = rhs.intakeNumber
}

func == (lhs: CalorieCount, rhs: CalorieCountRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: CalorieCountRepresentation, rhs: CalorieCount) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: CalorieCount, rhs: CalorieCountRepresentation) -> Bool {
    return rhs != lhs
}

