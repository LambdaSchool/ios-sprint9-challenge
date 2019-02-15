//
//  HeaderChartController.swift
//  CalorieIntake
//
//  Created by Benjamin Hakes on 2/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import SwiftChart
import CoreData

class HeaderChartController {
    
    static func setup() -> Chart {
        
        let headerView: Chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        series.area = true
        headerView.add(series)
        
        return headerView
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEvent> = {
        
        let fetchRequest: NSFetchRequest<CalorieEvent> = CalorieEvent.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform fetch on Core Data")
        }
        
        return frc
    }()
}
