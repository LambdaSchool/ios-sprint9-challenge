//
//  UserController.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class UserController {
	private(set) var users: [Int64: User] {
		get {
			guard let data = UserDefaults.standard.data(forKey: "Users") else { return [:] }
			return (try? PropertyListDecoder().decode([Int64: User].self, from: data)) ?? [:]
		}
		set {
			guard let data = try? PropertyListEncoder().encode(newValue) else { return }
			UserDefaults.standard.set(data, forKey: "Users")
		}
	}

	func user(forID id: Int64) -> User {
		if let user = users[id] {
			return user
		} else {
			let user = User(id: id, name: "User \(id)")
			update(user: user)
			return user
		}
	}

	func update(user: User) {
		users[user.id] = user
	}
}
