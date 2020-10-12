//
//  CaloriesTableView.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import UIKit

class CaloriesTableView: UITableView {
    
    let caloriesController = CaloriesController()

    override func numberOfRows(inSection section: Int) -> Int {
        caloriesController.calories.count
    }

}
