//
//  Track.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct Track {
	struct Calorie: Codable {
		let caloriesCount: Int
		let date: String
	}
	
	init (id: String = UUID().uuidString){
		self.id = id
	}
	
	let id: String
	var trackedCaloried: [Calorie] = []
}

