//
//  SetsVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/16/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class SetsVC: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    
    // MARK: - Variables
    var sets: Results<ExerciseSet>?
    var units = "lbs"
    
    // From WorkoutVC
    var selectedExerciseSlot: ExerciseSlot?
    
    // MARK: - Outlets
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var ormLabel: UILabel!
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    @IBOutlet weak var exerciseEquipLabel: UILabel!
    
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func reorderButtonPressed(_ sender: UIButton) {
        setsTableView.isEditing = !setsTableView.isEditing
    }
    
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure title
        if let exercise = selectedExerciseSlot?.exercise {
            exerciseNameLabel.text = "\(selectedExerciseSlot?.number ?? 0). \(exercise.name ?? "No name...")"
            exerciseTypeLabel.text = exercise.type
            exerciseEquipLabel.text = exercise.equipment
            ormLabel.text = exercise.oneRepMax != 0 ? "\(exercise.oneRepMax)\(units)" : "None"
        }
        
        // Configure view corner radius
        setsView.layer.cornerRadius = 10.0
        setsView.layer.masksToBounds = true
        reorderButton.layer.cornerRadius = 10.0
        
        
        // Set table view delegate and data source to current view controller
        setsTableView.delegate = self
        setsTableView.dataSource = self
        
        // Register custom table view cells
        setsTableView.register(UINib(nibName: "SetsPlanningCell", bundle: nil), forCellReuseIdentifier: "SetsCell")
        
        // Load exerciseSets if they already exist
        loadExerciseSets()
        
    }
    
    @objc func addButtonPressed() {
        do {
            try realm.write {
                
                // Creat new set
                let newSet = ExerciseSet()
                
                // Set number of new set to count of existing sets plus one
                newSet.number = (sets?.count ?? 0) + 1
                
                // Append new set to selected exercise slot
                selectedExerciseSlot?.exerciseSets.append(newSet)
                
                // Reload exercise sets
                loadExerciseSets()
            }
        } catch {
            print("Error creating new set...\(error)")
        }
        
        
        let indexPath = IndexPath(row: sets!.count - 1, section: 0)
        setsTableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    // MARK: - Load/Save data
    func loadExerciseSets() {
        if let slot = selectedExerciseSlot {
            // Load exercise sets ordered by number
            sets = slot.exerciseSets.sorted(byKeyPath: "number", ascending: true)
        }
    }
    
    func reorderSets(sets: List<ExerciseSet>) {
        for index in 0..<sets.count {
            sets[index].number = index + 1
        }
    }
    
    // MARK: - Textfield functions
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Cast textfield as custom textfield
        let selectedTextField = textField as! CustomTextField
        
        // Unwrap selected set
        if let selectedSet = selectedExerciseSlot?.exerciseSets[selectedTextField.row!] {
            
            // Make sure text field is not empty
            if selectedTextField.text != "" {
                do {
                    try realm.write {
                        // If selected textfield is reps textfield, update selected set's reps
                        if selectedTextField.tag == 0 {
                            selectedSet.repsTarget = Int(selectedTextField.text!) ?? 0
                            
                        // Otherwise, if selected textfield is weight textfield, update weight
                        } else if selectedTextField.tag == 1{
                            selectedSet.weightTarget = Int(selectedTextField.text!) ?? 0
                            
                            if let exercise = selectedExerciseSlot?.exercise {
                                // If exercise has a nonzero orm, set intensity target
                                if exercise.oneRepMax > 0 {
                                    selectedSet.intensityTarget = Double(selectedSet.weightTarget) / Double(exercise.oneRepMax)
                                }
                            }
                            
                        // Otherwise, update intensity if exercise type is main
                        } else {
                            if let exercise = selectedExerciseSlot?.exercise {
                                // Check that exercise type is main and orm is greater than zero
                                if exercise.type == "Main" && exercise.oneRepMax > 0 {
                                
                                    // Update set intensity target
                                    selectedSet.intensityTarget = (Double(selectedTextField.text!) ?? 0) / 100
                                    
                                    // Update set weight target based on intensity
                                    selectedSet.weightTarget = Int(selectedSet.intensityTarget * Double(exercise.oneRepMax))
                                }
                            }
                        }
                        setsTableView.reloadData()
                    }
                } catch {
                    print("Error updating exercise set...\(error)")
                }
            }
        }
        
    }
    



}

extension SetsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create UIView for header
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        
        // Load custom header view
        if let setsHeaderView = Bundle.main.loadNibNamed("SetsHeaderView", owner: self, options: nil)?.first as? SetsHeaderView {
        
            // Add custom view to headerView
            headerView.addSubview(setsHeaderView)
            setsHeaderView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height)
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)
        
        if let addItemView = Bundle.main.loadNibNamed("AddItemFooterView", owner: self, options: nil)?.first as? AddItemFooterView {
            
            footerView.addSubview(addItemView)
            addItemView.frame = CGRect(x: 0, y: 0, width: footerView.bounds.size.width, height: footerView.bounds.size.height)
            addItemView.addItemButton.setTitle("+ Add Set", for: .normal)
            addItemView.addItemButton.addTarget(self, action: #selector(WorkoutVC.addButtonPressed), for: .touchUpInside)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath) as! SetsPlanningCell
            
        // Set cell's setNumberButton to display set number
        cell.setNumberButton.setTitle("\(sets?[indexPath.row].number ?? 0)", for: .normal)
            
        // Track row of each textfield
        cell.repsTextField.row = indexPath.row
        cell.weightTextField.row = indexPath.row
        cell.intensityTextField.row = indexPath.row
            
            
        // Create toolbars in each cell's textfields
        createToolbar(chosenTextField: cell.repsTextField)
        createToolbar(chosenTextField: cell.weightTextField)
        createToolbar(chosenTextField: cell.intensityTextField)
            
        // Populate textfields with associated values if they are not 0
        if let set = sets?[indexPath.row] {
            if set.repsTarget != 0 {
                cell.repsTextField.text = "\(set.repsTarget)"
            } else {
                cell.repsTextField.text = ""
            }
                
            if set.weightTarget != 0 {
                cell.weightTextField.text = "\(set.weightTarget)"
            } else {
                cell.weightTextField.text = ""
            }
                
            if set.intensityTarget != 0.0 {
                cell.intensityTextField.text = "\(Int(set.intensityTarget * 100))"
            } else {
                cell.intensityTextField.text = ""
            }
        }
            
        // Set textfield delegates
        cell.repsTextField.delegate = self
        cell.weightTextField.delegate = self
        cell.intensityTextField.delegate = self
            
        if selectedExerciseSlot?.exercise?.type != "Main" {
            cell.intensityTextField.text = "N/A"
            cell.intensityTextField.isEnabled = false
        }
            
            
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedSets = selectedExerciseSlot?.exerciseSets {
                do {
                    try realm.write {
                        // Delete selected set from list of exercise sets
//                        selectedSets.remove(at: indexPath.row)
                        realm.delete(selectedSets[indexPath.row])

                        // Reload exercise sets
                        loadExerciseSets()

                        // Renumber existing sets
                        reorderSets(sets: selectedSets)
                        
                        // Reload table view
                        setsTableView.reloadData()
                    }
                } catch {
                    print("Error removing exercise set...\(error)")
                }
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let selectedSets = selectedExerciseSlot?.exerciseSets {
            do {
                try realm.write {
                    if let selectedSet = selectedExerciseSlot?.exerciseSets[sourceIndexPath.row] {
                        selectedExerciseSlot?.exerciseSets.remove(at: sourceIndexPath.row)
                        selectedExerciseSlot?.exerciseSets.insert(selectedSet, at: destinationIndexPath.row)
                        reorderSets(sets: selectedSets)
                    }
                setsTableView.reloadData()
                }
            } catch {
                print("Error reordering exercise sets...\(error)")
            }
        }
    }
}


