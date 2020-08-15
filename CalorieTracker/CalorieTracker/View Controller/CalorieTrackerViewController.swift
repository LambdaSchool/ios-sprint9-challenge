//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Josh Kocsis on 8/14/20.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController {

    @IBOutlet private weak var chart: Chart!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()

        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: CoreDataStack.shared.mainContext)
    }

   @objc func updateChart() {
        var tracker: [Tracker] {
            let fetchRequest: NSFetchRequest<Tracker> = Tracker.fetchRequest()
            let context = CoreDataStack.shared.mainContext
            do {
                return try context.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching tracker: \(error)")
                return []
            }
        }

        let calorieNumbers = tracker.map { Double($0.calories) }
        let series = ChartSeries(calorieNumbers)
        chart.removeAllSeries()
        chart.add(series)
    }
}
