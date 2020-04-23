//
//  PersistenceProtocol.swift
//  iOSSprintCalorieTracker
//
//  Created by Patrick Millet on 1/31/20.
//  Copyright © 2020 Patrick Millet. All rights reserved.
//

import Foundation

protocol PersistentContext {}

protocol Persistable {}

protocol PersistentStoreController: AnyObject {
    var delegate: PersistentStoreControllerDelegate? { get set }
    
    var allItems: [Persistable]? { get }
    var itemCount: Int { get }
    
    var mainContext: PersistentContext { get }
    
    func create(item: Persistable, in context: PersistentContext?) throws
    func fetchItem(at indexPath: IndexPath) -> Persistable?
    func delete(_ item: Persistable?, in context: PersistentContext?) throws
    func deleteShort(
        itemAtIndexPath indexPath: IndexPath,
        in context: PersistentContext?) throws
    
    func save(in context: PersistentContext?) throws
}

