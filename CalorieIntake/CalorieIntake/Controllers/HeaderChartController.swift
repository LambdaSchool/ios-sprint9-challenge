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
    
    init(){
        self.chart = Chart()
        self.series = ChartSeries([])
        setup()
        
    }
    
    func setup() {
        
        chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        updateChartFromCoreData()
        series.area = true
        chart.add(series)
    
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEvent> = {
        
        let fetchRequest: NSFetchRequest<CalorieEvent> = CalorieEvent.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform fetch on Core Data")
        }
        
        return frc
    }()
    
    func updateChartFromCoreData(){

        let fetchedResult = fetchCalorieEvents()
        series.data = []
        for index in 0..<fetchedResult.count{
            let calorieEvent = fetchedResult[index]
            let amount = calorieEvent.numberOfCalories
            series.data.append((x: Double(index), y: amount))
        }
        chart.series = [series]
    }
    
    private func fetchCalorieEvents()-> [CalorieEvent] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<CalorieEvent>(entityName: "CalorieEvent")
        var fetchedResults: [CalorieEvent] = []
        do {
            fetchedResults = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        
        return fetchedResults
        
    }
    
    // MARK: Properties
    
    var chart: Chart
    var series: ChartSeries
    
}
