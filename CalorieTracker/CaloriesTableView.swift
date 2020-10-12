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
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CaloriesTableViewCell else {
            fatalError("Can't dequeue cell of type CalorieCell")
        }

        return cell
    }

}
