//
//  CalorieCell.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class CalorieCell: UITableViewCell
{
    let dateLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 8, paddingBottom: 0, width: 0, height: 0)
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
