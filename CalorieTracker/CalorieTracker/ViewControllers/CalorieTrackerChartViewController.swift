//
//  CalorieTrackerChartViewController.swift
//  CalorieTracker
//
//  Created by Shawn Gee on 4/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import CoreData
import SwiftChart
import UIKit

class CalorieTrackerChartViewController: UIViewController {
    
    typealias Coordinate = (x: Int, y: Double)
    
    // MARK: - Private Properties
    
    private var chartView: Chart!
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        chartView = Chart(frame: .zero)
        view = chartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChart()
        updateChart(nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(_:)), name: .calorieEntryAdded, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setUpChart() {
        chartView.minY = 0
    }
    
    @objc private func updateChart(_ notification: Notification?) {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let calorieEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            let coordinates = calorieEntries.reduce([]) { previousResult, calorieEntry -> [Coordinate] in
                let coordinate = Coordinate(previousResult.count, Double(calorieEntry.calories))
                return previousResult + [coordinate]
            }
            
            let series = ChartSeries(data: coordinates)
            series.area = true
            chartView.series = [series]
        } catch {
            print(error)
        }
    }
}
