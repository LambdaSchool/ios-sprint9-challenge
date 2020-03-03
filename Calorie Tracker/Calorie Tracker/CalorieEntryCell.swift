//
//  CalorieEntryCell.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import UIKit

class CalorieEntryCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
}
