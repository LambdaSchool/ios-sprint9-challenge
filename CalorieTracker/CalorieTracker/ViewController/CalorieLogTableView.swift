//
//  CalorieLogTableView.swift
//  CalorieTracker
//
//  Created by Zachary Thacker on 10/12/20.
//

import UIKit
import CoreData

class CalorieLogTableView: UITableView, NSFetchedResultsControllerDelegate {
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CalorieLog> = {
        let request: NSFetchRequest<CalorieLog> = CalorieLog.fetchRequest()
        request.sortDescriptors = [
            .init(key: "date", ascending: true,
             selector: #selector(NSString.localizedStandardCompare(_:))), 
        ]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
}
