//
//  MainTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class MainTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var calorieList: [Calorie] = []
    
    // Mock Data
    var mockCalorie: Calorie = Calorie(calorieAmount: "Calorie", savedDate: "Today")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieList.append(mockCalorie)
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieList.count
    }
    //Displays all the cells on load
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath) as? CellCalorieTrackerTableViewCell else { return UITableViewCell() }
        
        cell.isAccessibilityElement = false
        
        let calorie = calorieList[indexPath.row]
        
        cell.setOption(calorie: calorie)
        
        return cell
    }

}
