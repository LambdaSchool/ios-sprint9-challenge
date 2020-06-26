//
//  WaterPlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/25/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import UIKit

protocol PlantCellDelegate {
    func timerInitator(plant: Plant) -> Void
}

class WaterPlantTableViewCell: UITableViewCell {

        // MARK: - Outlets
        @IBOutlet weak var plantNickname: UILabel!
        @IBOutlet weak var plantSpecies: UILabel!
        @IBOutlet weak var plantWateredButton: UIButton!
        // MARK: - Properties
        var plant: Plant? {
            didSet {
                updateViews()
            }
        }
         var delegate: PlantCellDelegate?
        var isPlantWatered: Bool = false
        @IBAction func waterPlantButtonTapped(_ sender: UIButton) {
            guard let plant = plant else { return }
            plant.isWatered.toggle()
            updateViews()
            // Start Timer
            runTimer()
        }
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        // MARK: - Private Functions
        private func runTimer() {
            guard let plant = plant else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + plant.h2oFrequency) {
                plant.isWatered = false
                self.updateViews()
                self.delegate?.timerInitator(plant: plant)
            }
        }
        private func updateViews() {
            guard let plant = plant else { return }
            plantNickname.text = plant.plantName
            plantSpecies.text = plant.species
            if plant.isWatered == false {
                plantWateredButton.isEnabled = true
                plantWateredButton.setImage(#imageLiteral(resourceName: "UncoloredPlantUpset.png") ,
                                            for: .normal)
            } else if plant.isWatered {
                plantWateredButton.isEnabled = false
                plantWateredButton.setImage( #imageLiteral(resourceName: "UncoloredPlant.png") ,
                                             for: .normal)
            }
        }
    }
