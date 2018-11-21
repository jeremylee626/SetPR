//
//  ActiveSetsVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/19/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class ActiveSetsVC: UIViewController, UITextFieldDelegate {

    let realm = try! Realm()
    
    // MARK: - Variables
    var selectedExerciseSlot: ExerciseSlot?
    var sets: Results<ExerciseSet>?
    var workout: Workout?
    
    // MARK: - Outlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var ormLabel: UILabel!
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let currentIndex = selectedExerciseSlot?.number, let slots = workout?.exerciseSlots {
            // Set next index to current index plus 1 or 1 if current index is last index
            let nextIndex = (currentIndex != slots.count) ? (currentIndex + 1) : 1
    
            // Set selected exercise slot to next slot in sequence
            selectedExerciseSlot = slots.filter("number == %@", nextIndex).first
            // Reload exercise sets data
            loadExerciseSets()
            
            // Reload table view
            setsTableView.reloadData()

            // Reload exercise info labels
            setupExerciseInfoLabels()

        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let currentIndex = selectedExerciseSlot?.number, let slots = workout?.exerciseSlots {
            // If current slot number is not 1, subtract 1 from current index, otherwise set to last slot
            let prevIndex = (currentIndex != 1) ? (currentIndex - 1) : slots.count
            
            // Set selected exercise slot to previous slot
            selectedExerciseSlot = slots.filter("number == %@", prevIndex).first
            // Reload exercise sets data
            loadExerciseSets()
            
            // Reload table view
            setsTableView.reloadData()
            
            // Reload exercise info labels
            setupExerciseInfoLabels()
        }
        
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
    }
    
    
    
    @IBAction func reorderButtonPressed(_ sender: UIButton) {
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
                            selectedSet.repsPerformed = Int(selectedTextField.text!) ?? 0
                            
                            // Otherwise, if selected textfield is weight textfield, update weight
                        } else if selectedTextField.tag == 1{
                            selectedSet.weightPerformed = Int(selectedTextField.text!) ?? 0
                            
                            if let exercise = selectedExerciseSlot?.exercise {
                                // If exercise has a nonzero orm, set intensity target
                                if exercise.oneRepMax > 0 {
                                    selectedSet.intensityPerformed = Double(selectedSet.weightPerformed) / Double(exercise.oneRepMax)
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
    
    // MARK: - Setup functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure exercise detail labels
        setupExerciseInfoLabels()
        
        // Add corner radius to view
        setsView.layer.cornerRadius = 10.0
        setsView.layer.masksToBounds = true
        
        // Configure exit button appearance
        exitButton.layer.cornerRadius = exitButton.bounds.size.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        exitButton.layer.borderWidth = 2.0
        
        // Configure reorder button appearance
        reorderButton.layer.cornerRadius = 10.0
        reorderButton.layer.masksToBounds = true
        reorderButton.sizeToFit()
        
        // Set tableview delegate and data source
        setsTableView.delegate = self
        setsTableView.dataSource = self
        
        // Register custom table view cell
        setsTableView.register(UINib(nibName: "ActiveSetsCell", bundle: nil), forCellReuseIdentifier: "SetsCell")
        
        // Load sets data
        loadExerciseSets()
        
    }
    
    func setupExerciseInfoLabels() {
        // Configure exercise detail labels
        if let exercise = selectedExerciseSlot?.exercise {
            exerciseNameLabel.text = "\(selectedExerciseSlot?.number ?? 0). \(exercise.name ?? "No name...")"
            exerciseTypeLabel.text = exercise.type
            equipmentLabel.text = exercise.equipment
            ormLabel.text = exercise.oneRepMax > 0 ? "\(exercise.oneRepMax)" : "None"
        }
    }
    // MARK: - Navigation

    // MARK: - Load/Save data
    func loadExerciseSets() {
        if let slot = selectedExerciseSlot {
            // Load exercise sets ordered by number
            sets = slot.exerciseSets.sorted(byKeyPath: "number", ascending: true)
        }
    }
}


extension ActiveSetsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderViewFromNib(nibName: "SetsHeaderView", height: 35)
        let headerSubView = headerView.subviews.first as! SetsHeaderView
        headerSubView.intensityLabel.text = "Rest"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = createAddFooterViewFromNib(nibName: "AddItemFooterView", height: 45, buttonTitle: "+ Add Set")
        let footerSubView = footerView.subviews.first as! AddItemFooterView
        footerSubView.addItemButton.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath) as! ActiveSetsCell
        
        // Set reps and weight textfield place holders to target reps and weight
        if let currentSet = sets?[indexPath.row] {
            cell.repsTextField.placeholder = currentSet.repsTarget > 0 ? "\(currentSet.repsTarget)" : "-"
            cell.weightTextField.placeholder = currentSet.weightTarget > 0 ? "\(currentSet.weightTarget)" : "-"
        }
        
        // Create toolbars within each textfield
        createToolbar(chosenTextField: cell.repsTextField)
        createToolbar(chosenTextField: cell.weightTextField)
        
        // Set selected textfields row property
        cell.repsTextField.row = indexPath.row
        cell.weightTextField.row = indexPath.row
        
        return cell
    }
}
