//
//  WaterPlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/25/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import UIKit

class WaterPlantDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    // MARK: - Properties
    let imagePickerController = UIImagePickerController()
    var plant: Plant?
    var waterController: WaterController?
    enum PickerOptions: String, CaseIterable {
        case waterOnceADay = "Water Once A Day"
        case waterTwiceADay = "Water Twice A Day"
        case waterEveryTwoDays = "Water Every Two Days"
        case waterEveryThreeDays = "Water Every Three Days"
        case waterEveryOnceAWeek = "Water Once A week"
    }
    private var pickerData: [String] {
        var pickerData = [String]()
        for data in PickerOptions.allCases {
            pickerData.append(data.rawValue)
        }
        return pickerData
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        pickerView.delegate = self
        pickerView.dataSource = self
        frequencyTextField.delegate = self
        pickerView.isHidden = true
        plantNameTextField.text = plant?.plantName
        speciesTextField.text = plant?.species
        frequencyTextField.text = waterFrequencyText()
        if let image = plant?.image {
            let data = image.data(using: .utf8)!
            imageView.image = UIImage(data: data)
        }
    }
    // MARK: - Methods
    @IBAction func savePlantButton(_ sender: Any) {
        guard let plantName = plantNameTextField.text,
            let species = speciesTextField.text else { return }
        if let plant = plant {
            plant.plantName = plantName
            plant.species = species
            plant.h2oFrequency = waterFrequency()
            waterController?.sendPlantToServer(plant: plant, completion: { result in
                switch result {
                case .success(_):
                    print("Groovy")
                case .failure(_):
                    print("Try again!")
                }
            })
        } else {
            let plant = Plant(name: plantName, species: species, image: nil, frequency: waterFrequency())
            waterController?.sendPlantToServer(plant: plant,
                                             completion: { result in
                                                switch result {
                                                case .success(_ ):
                                                    print("Groovy")
                                                case .failure(_ ):
                                                    print("Try again!")
                                                }
            })
        }
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func imageButton(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func waterFrequency() -> Double {
        guard let frequency = frequencyTextField.text else { return 0 }
        switch frequency {
        case PickerOptions.waterOnceADay.rawValue:
            return 300
        case PickerOptions.waterTwiceADay.rawValue:
            return 200
        case PickerOptions.waterEveryTwoDays.rawValue:
            return 100
        case PickerOptions.waterEveryThreeDays.rawValue:
            return 844
        default:
            return 0
        }
    }
    private func waterFrequencyText() -> String? {
        guard let plant = plant else { return nil }
        switch plant.h2oFrequency {
        case 300:
            return PickerOptions.waterOnceADay.rawValue
        case 200:
            return PickerOptions.waterTwiceADay.rawValue
        case 100:
            return PickerOptions.waterEveryTwoDays.rawValue
        case 844:
            return PickerOptions.waterEveryThreeDays.rawValue
        default:
            return nil
        }
    }
}

extension WaterPlantDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequencyTextField.text = pickerData[row]
        pickerView.isHidden = true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        return false
    }
}

extension WaterPlantDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.imagePickerController(picker, didSelect: nil)
        }
        imageView.image = image
        if let plant = plant {
            let dataString = String(data: (imageView.image?.pngData()!)!, encoding: .utf8)
            plant.image = dataString
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
