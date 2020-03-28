//
//  PersistenceProtocols.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

protocol PersistentStoreController: AnyObject {
    var delegate: PersistentStoreControllerDelegate? { get set }

    var allItems: [Persistable]? { get }
    var itemCount: Int { get }

    var mainContext: PersistentContext { get }

    func create(item: Persistable, in context: PersistentContext?) throws
    func getItem(at indexPath: IndexPath) -> Persistable?
    func delete(_ item: Persistable?, in context: PersistentContext?) throws
    func delete(
        itemAtIndexPath indexPath: IndexPath,
        in context: PersistentContext?) throws

    func save(in context: PersistentContext?) throws
}

protocol PersistentContext {}

protocol Persistable {}
