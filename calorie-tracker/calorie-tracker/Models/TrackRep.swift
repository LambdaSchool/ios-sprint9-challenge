//
//  Track.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct TrackRepresentation {
	struct Calorie: Codable {
		let caloriesCount: Int
		let date: Date
	}
	
	init (id: String = UUID().uuidString){
		self.id = id
	}
	
	let id: String
	var caloriesList: [Calorie] = []
}


