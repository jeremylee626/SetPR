//
//  NewExerciseVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/8/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class NewExerciseVC: UIViewController {
    
    // Initialize realm
    let realm = try! Realm()
    
    // MARK: Vars
    var types = ["", "Main", "Variation", "Accessory", "Other"]
    var muscles = ["", "Chest", "Back", "Shoulders", "Biceps", "Triceps", "Quads",
                   "Hamstrings", "Calves", "Core", "Fullbody", "Cardio", "Other"]
    var equipmentChoices = ["", "Barbell", "Dumbbell", "Machine", "Cable", "Body Weight",
                            "Other"]
    
    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var muscleTextField: UITextField!
    @IBOutlet weak var equipmentTextField: UITextField!
    @IBOutlet weak var ormTextField: UITextField!
    @IBOutlet weak var infoWindow: UIView!
    
    // MARK: Actions
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let newExercise = Exercise()
        newExercise.name = nameTextField.text
        newExercise.type = typeTextField.text
        newExercise.muscleGroup = muscleTextField.text
        newExercise.equipment = equipmentTextField.text
        if let oneRepMax = ormTextField.text {
            newExercise.oneRepMax = newExercise.type == "Main" ? Int(oneRepMax) ?? 0 : 0
        }
        
        // Save new exercise
        saveNewExercise(exercise: newExercise)
    }
    
    // Do nothing if cancel button pressed
    @IBAction func cancelButtonPressed(_ sender: UIButton) {}
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        infoWindow.layer.cornerRadius = 10.0
        infoWindow.clipsToBounds = true
        
        navigationController?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        createPickers()
        createToolbars()
    
    }
    
    func createPickers() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        typePicker.tag = 0
        typePicker.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        typeTextField.inputView = typePicker
        
        let musclePicker = UIPickerView()
        musclePicker.delegate = self
        musclePicker.tag = 1
        musclePicker.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        muscleTextField.inputView = musclePicker
        
        let equipmentPicker = UIPickerView()
        equipmentPicker.delegate = self
        equipmentPicker.tag = 2
        equipmentPicker.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        equipmentTextField.inputView = equipmentPicker
        
    }
    
    func createToolbars() {
        // Create toolbar
        let toolbar = UIToolbar()
        toolbar.backgroundColor = .gray
        toolbar.sizeToFit()
        
        // Add done button
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)
        
        // Input toolbars in textfields
        nameTextField.inputAccessoryView = toolbar
        typeTextField.inputAccessoryView = toolbar
        muscleTextField.inputAccessoryView = toolbar
        equipmentTextField.inputAccessoryView = toolbar
        ormTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonPressed() {
        view.endEditing(true)
    }
    
    // MARK: Saving data
    func saveNewExercise(exercise: Exercise) {
        // Try to write new exercise to realm
        do {
            try realm.write {
                realm.add(exercise)
            }
        } catch {
            print("Error creating new exercise: \(error)")
        }
    }

}



extension NewExerciseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return count based on picker view tag
        if pickerView.tag == 0 {
            return types.count
        } else if pickerView.tag == 1 {
            return muscles.count
        } else {
            return equipmentChoices.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Return title based on picker view tag
        if pickerView.tag == 0 {
            return types[row]
        } else if pickerView.tag == 1 {
            return muscles[row]
        } else {
            return equipmentChoices[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Change textfield based on picker view tag
        if pickerView.tag == 0 {
            typeTextField.text = types[row]
            if typeTextField.text != "Main" {
                ormTextField.isUserInteractionEnabled = false
                ormTextField.text = "N/A"
            } else {
                ormTextField.isUserInteractionEnabled = true
                ormTextField.text = ""
                ormTextField.placeholder = "Enter 1RM"
            }
        } else if pickerView.tag == 1 {
            muscleTextField.text = muscles[row]
        } else if pickerView.tag == 2 {
            equipmentTextField.text = equipmentChoices[row]
        }
    }
    
    
}
