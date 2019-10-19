//
//  Chart.swift
//  CalorieTracker
//
//  Created by Ciara Beitel on 10/18/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit
import SwiftChart

class Chart: UIView {

    let chart = Chart()
    
    let data = [
      (x: 0, y: 0),
      (x: 1, y: 3.1),
      (x: 4, y: 2),
      (x: 5, y: 4.2),
      (x: 7, y: 5),
      (x: 9, y: 9),
      (x: 10, y: 8)
    ]
    
    let series = ChartSeries(data: data)
    
    //chart.add(series)

}
