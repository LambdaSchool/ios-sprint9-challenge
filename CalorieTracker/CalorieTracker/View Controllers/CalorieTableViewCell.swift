//
//  CalorieTableViewCell.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    var calorie: Calorie?
    
    private func updateViews() {
        guard let calorie = calorie else { return }
    }
}
