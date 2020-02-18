//
//  CalorieIntakePopover.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import Popover

let screen = UIScreen.main.bounds

var newCalorieIntakePopover: Popover = {
    
    let popover = Popover(options: [.animationIn(0.275),
                                    .animationOut(0.2),
                                    .cornerRadius(14),
                                    .color(UIColor(named: "Background") ?? .clear),
                                    .blackOverlayColor(UIColor(named: "PopoverBackground") ?? .clear),
                                    .arrowSize(CGSize(width: 0.1, height: 0.1)),
                                    .initialSpringVelocity(CGFloat(0.2)),
                                    .springDamping(CGFloat(0.92))],
                          showHandler: nil,
                          dismissHandler: nil)
    
    popover.layer.shadowOpacity = 0.4
    popover.layer.shadowOffset = CGSize(width: 0, height: 3)
    popover.layer.shadowRadius = 7
    popover.layer.opacity = 1
    
    return popover
}()

// MARK:- Popover manager class

class CalorieIntakePopover {
    
    static let shared = CalorieIntakePopover()
    
    func trigger() {
        let popoverView = NewCalorieIntakeView.instantiate()
        popoverView.frame = CGRect(x: 20, y: 0, width: screen.width - 40, height: 260)
        
        let startPoint = CGPoint(x: screen.width / 2, y: 168)
        newCalorieIntakePopover.show(popoverView, point: startPoint)
    }
    
}
