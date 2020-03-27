//
//  CalorieEntryCell.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class CalorieEntryCell: UITableViewCell {
    let caloriesLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureCalorieslabel()
        configureDatelabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCalorieslabel() {
        addSubview(caloriesLabel)
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        caloriesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        caloriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        caloriesLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func configureDatelabel() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
    }
    
}
