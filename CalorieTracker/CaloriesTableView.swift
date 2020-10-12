//
//  CaloriesTableView.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import UIKit

class CaloriesTableView: UITableView {
    
    var caloriesController: CaloriesController?
    
    override func numberOfRows(inSection section: Int) -> Int {
        if let controller = caloriesController {
            return controller.calories.count
        }
        return 0
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CaloriesTableViewCell else {
            fatalError("Can't dequeue cell of type CalorieCell")
        }

        return cell
    }

}
