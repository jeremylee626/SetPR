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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    // MARK: Actions
    @IBAction func startWorkoutButtonPressed(_ sender: UIButton) {
        let startDate = Date()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E, d MMM yyyy"
        dateLabel.text = dateFormatterGet.string(from: startDate)
        
        do {
            try  realm.write {
                if let workout = workout {
                    workout.isActive = !workout.isActive
                    setupStartWorkoutButton()
                }
                
                if let firstSlot = workoutExerciseSlots?.first {
                    firstSlot.isActive = !firstSlot.isActive
                }
                workoutTableView.reloadData()
            }
            
        } catch {
            print("Error starting workout...\(error)")
        }
        
    }
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set screen title
        navigationItem.title = "Week \(workout?.cycleNumber ?? 0), Day \(workout?.dayNumber ?? 0)"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure start workout button
        startWorkoutButton.layer.cornerRadius = startWorkoutButton.bounds.size.width / 2
        startWorkoutButton.layer.masksToBounds = true
        startWorkoutButton.layer.borderWidth = 2.0
        setupStartWorkoutButton()
        
        // Set info labels
        workoutNameLabel.text = workout?.name
        
        
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
    
    func updateMusclesLabel() {
        if let muscles = workout?.muscles {
            let affectedMuscles = Array(Set(muscles))
            var labelString = ""
            for i in 0..<affectedMuscles.count {
                labelString += i < affectedMuscles.count - 1 ? affectedMuscles[i] + ", " : affectedMuscles[i]
            }
            
            musclesLabel.text = labelString
        }
    }
    
    func setupStartWorkoutButton() {
        if let workout = workout {
            if workout.isActive {
                startWorkoutButton.setTitle("Finish", for: .normal)
                startWorkoutButton.backgroundColor = #colorLiteral(red: 1, green: 0.4182741796, blue: 0.4273440738, alpha: 1)
                startWorkoutButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            } else {
                startWorkoutButton.setTitle("Start", for: .normal)
                startWorkoutButton.backgroundColor = #colorLiteral(red: 0.5692999382, green: 1, blue: 0.6264482415, alpha: 1)
                startWorkoutButton.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
        }
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
        } else if segue.identifier == "goToActiveSetsVC" {
            let destinationVC = segue.destination as! ActiveSetsVC
            destinationVC.selectedExerciseSlot = selectedExerciseSlot
            destinationVC.workout = workout
        }
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: "goToExerciseBank", sender: self)
    }
    
    @objc func beginSets(_ sender: UIButton) {
        selectedExerciseSlot = workoutExerciseSlots?[sender.tag]
        if selectedExerciseSlot?.isActive == true {
            performSegue(withIdentifier: "goToActiveSetsVC", sender: self)
        }
    }
    
    @IBAction func unwindToWorkoutVC(_ sender: UIStoryboardSegue) {
        workoutTableView.reloadData()
        updateMusclesLabel()
    }
    
    // MARK: Load/Save Data
    func loadWorkoutExercises() {
        // Load exercise slots filtered by parent workout name sorted by number
        workoutExerciseSlots = realm.objects(ExerciseSlot.self).filter("ANY parentWorkout.name == %@", workout!.name!).sorted(byKeyPath: "number", ascending: true)
        
        updateMusclesLabel()
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
        headerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        let topPadding = CGFloat(5.0)
        let screenWidth = UIScreen.main.bounds.width
        let labelWidth = screenWidth - 70
        
        
        let title = UILabel()
        let textSize = CGFloat(20.0)
        title.text = " Exercises"
        title.font = UIFont(name: "American Typewriter", size: textSize)
        title.frame = CGRect(x: 0, y: topPadding, width: labelWidth, height: 35)
        headerView.addSubview(title)
        
        
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        editButton.layer.cornerRadius = 5.0
        editButton.addTarget(self, action: #selector(WorkoutVC.editButtonPressed), for: .touchUpInside)
        editButton.frame = CGRect(x: 10 + labelWidth, y: topPadding, width: 50, height: 35)
        headerView.addSubview(editButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)
        
        if let addItemView = Bundle.main.loadNibNamed("AddItemFooterView", owner: self, options: nil)?.first as? AddItemFooterView {
            
            footerView.addSubview(addItemView)
            addItemView.frame = CGRect(x: 0, y: 0, width: footerView.bounds.size.width, height: footerView.bounds.size.height)
            addItemView.addItemButton.setTitle("+ Add Exercise", for: .normal)
            addItemView.addItemButton.addTarget(self, action: #selector(WorkoutVC.addButtonPressed), for: .touchUpInside)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutExerciseSlots?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create workout exercise cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutExerciseCell", for: indexPath) as! WorkoutExerciseCell
            
        // Exercise for current exercise slot
        let exerciseSlot = workoutExerciseSlots?[indexPath.row]
            
        // Set number button label
        if exerciseSlot?.isActive == true {
            cell.numberButton.setTitle("Begin", for: .normal)
            cell.numberButton.backgroundColor = #colorLiteral(red: 0.4787004452, green: 1, blue: 0.1358468484, alpha: 1)
            cell.numberButton.tag = indexPath.row
            cell.numberButton.addTarget(self, action: #selector(self.beginSets(_:)), for: .touchUpInside)
            
        } else {
            cell.numberButton.setTitle("\(workoutExerciseSlots?[indexPath.row].number ?? 0)", for: .normal)
            cell.numberButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        }
        
        // Set name label
        cell.nameLabel.text = exerciseSlot?.exercise?.name ?? "No exercise name specified..."
        
        if let sets = exerciseSlot?.exerciseSets {
            if sets.count > 0 {
                var setDetails = ""
                for i in 0..<sets.count {
                    if i < sets.count - 1 {
                        setDetails += "Set \(sets[i].number): \(sets[i].weightTarget) x \(sets[i].repsTarget)\n"
                    } else {
                        setDetails += "Set \(sets[i].number): \(sets[i].weightTarget) x \(sets[i].repsTarget)"
                    }
                }
                
                cell.setsLabel?.numberOfLines = sets.count
                cell.setsLabel?.text = setDetails
            } else {
                cell.setsLabel?.text = "Tap row to enter sets..."
            }
        }
        
        cell.accessoryType = .disclosureIndicator
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let exerciseSlots = workoutExerciseSlots {
            selectedExerciseSlot = exerciseSlots[indexPath.row]
            performSegue(withIdentifier: "goToSetsVC", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
                    
                    // Update order of remaining exercise slots
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
        if editingStyle == .delete {
            if let slots = workout?.exerciseSlots {
                do {
                    try realm.write {
                        // Delete exercise sets from selected slot
                        realm.delete(slots[indexPath.row].exerciseSets)
//                        slots[indexPath.row].exerciseSets.removeAll()
                        
                        
                        // Delete exercise muscle from workout muscles
                        if let muscleToDelete = slots[indexPath.row].exercise?.muscleGroup {
                            if let muscleIndex = workout?.muscles.index(of: muscleToDelete) {
                                workout?.muscles.remove(at: muscleIndex)
                            }
                        }
                        
                        // Delete slot
                        realm.delete(slots[indexPath.row])
//                        slots.remove(at: indexPath.row)
                        
                        
                        
                        // Update slot numbers
                        reorderSlots(slots: slots)
                        
                        // Reload table view
                        workoutTableView.reloadData()
                        
                        // Reload muscles label
                        updateMusclesLabel()
                    }
                } catch {
                    print("Error deleting exercise slot...\(error)")
                }
            }
        }
    }

}
