//
//  WorkoutVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/9/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutVC: UIViewController {
    
    // Create realm instance
    let realm = try! Realm()
    
    // MARK: Variables
    var workout: Workout?
    var workoutExerciseSlots: Results<ExerciseSlot>?
    var selectedExerciseSlot: ExerciseSlot?
    
    // MARK: Outlets
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    
    // MARK: Actions
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set screen title
        navigationItem.title = workout?.name ?? "Error"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set info labels
        workoutNameLabel.text = workout?.name
        weekNumberLabel.text = "\(workout?.cycleNumber ?? 0)"
        dayNumberLabel.text = "\(workout?.dayNumber ?? 0)"
        
        
        // Set table view delegate and data source
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        
        // Register custom table view cells
        workoutTableView.register(UINib(nibName: "WorkoutExerciseCell", bundle: nil), forCellReuseIdentifier: "WorkoutExerciseCell")
        workoutTableView.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "AddCell")
        workoutTableView.rowHeight = UITableView.automaticDimension
        workoutTableView.estimatedRowHeight = 70
        
        // Load exercises
        loadWorkoutExercises()
        workoutTableView.reloadData()
        
    }
    
    @objc func editButtonPressed() {
        workoutTableView.isEditing = !workoutTableView.isEditing
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseBank" {
            // Pass workout to ExerciseBankVC
            let destinationVC = segue.destination as! ExerciseBankVC
            destinationVC.selectedWorkout = workout
        } else if segue.identifier == "goToSetsVC" {
            let destinationVC = segue.destination as! SetsVC
            destinationVC.selectedExerciseSlot = selectedExerciseSlot
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToExerciseBank", sender: self)
    }
    
    @IBAction func unwindToWorkoutVC(_ sender: UIStoryboardSegue) {
        workoutTableView.reloadData()
    }
    
    // MARK: Load/Save Data
    func loadWorkoutExercises() {
        // Load exercise slots filtered by parent workout name sorted by number
        workoutExerciseSlots = realm.objects(ExerciseSlot.self).filter("ANY parentWorkout.name == %@", workout!.name!).sorted(byKeyPath: "number", ascending: true)
        
    }
    
    func reorderSlots(slots: List<ExerciseSlot>) {
        // Loop through each slot
        for index in 0..<slots.count {
            // Set exercise slot number to index plus one
            slots[index].number = index + 1
        }
    }
    
}

extension WorkoutVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        let topPadding = CGFloat(5.0)
        let screenWidth = UIScreen.main.bounds.width
        let labelWidth = screenWidth - 70
        
        
        let title = UILabel()
        let textSize = CGFloat(20.0)
        title.text = " Exercises"
        title.font = UIFont(name: "Rockwell", size: textSize)
        title.font = UIFont.boldSystemFont(ofSize: textSize)
        title.frame = CGRect(x: 0, y: topPadding, width: labelWidth, height: 35)
        headerView.addSubview(title)
        
        
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(WorkoutVC.editButtonPressed), for: .touchUpInside)
        editButton.frame = CGRect(x: 10 + labelWidth, y: topPadding, width: 50, height: 35)
        headerView.addSubview(editButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workoutExerciseSlots?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check if index path row is equal to count of workoutExerciseSlots
        if indexPath.row == workoutExerciseSlots?.count {
            // Create add cell in table view
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
            
            // Add target to add button
            cell.addButton.addTarget(self, action: #selector(WorkoutVC.addButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        // Otherwise, if index path row not equal to count of workoutExerciseSlots
        } else {
            // Create workout exercise cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutExerciseCell", for: indexPath) as! WorkoutExerciseCell
            
            // Exercise for current exercise slot
            let exercise = workoutExerciseSlots?[indexPath.row].exercise
            
            // Set number label and name label of cell
            cell.numberLabel.text = "\(workoutExerciseSlots?[indexPath.row].number ?? 0)"
            cell.nameLabel.text = exercise?.name ?? "No exercise name specified..."
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let exerciseSlots = workoutExerciseSlots {
            selectedExerciseSlot = exerciseSlots[indexPath.row]
            performSegue(withIdentifier: "goToSetsVC", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == workoutExerciseSlots?.count {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let slots = workout?.exerciseSlots {
            do {
                try realm.write {
                    // Exercise slot to move
                    let slotToMove = slots[sourceIndexPath.row]
                    
                    // Remove exercise slot
                    slots.remove(at: sourceIndexPath.row)
                    
                    // Reinsert exercise slot at destination index
                    slots.insert(slotToMove, at: destinationIndexPath.row)
                    
                    // Reset exercise slot numbers
//                    for index in 0..<slots.count {
//                        slots[index].number = index + 1
//                    }
                    reorderSlots(slots: slots)
                    
                    workoutTableView.reloadData()
                    
                }
            } catch {
                print("Error updating exercise order...\(error)")
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Check that editing style is delete and selected row is not the add cell
        if editingStyle == .delete && indexPath.row != workoutExerciseSlots?.count {
            if let slots = workout?.exerciseSlots {
                do {
                    try realm.write {
                        // Delete exercise sets from selected slot
                        slots[indexPath.row].exerciseSets.removeAll()
                        
                        // Delete slot
                        slots.remove(at: indexPath.row)
                    
                        
                        // Update slot numbers
                        reorderSlots(slots: slots)
                        
                        workoutTableView.reloadData()
                    }
                } catch {
                    print("Error deleting exercise slot...\(error)")
                }
            }
        }
    }

}
