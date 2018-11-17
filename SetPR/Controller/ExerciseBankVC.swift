//
//  ViewController.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseBankVC: UIViewController {
    
    let realm = try! Realm()
    
    // MARK: Variables
    var allExercises: Results<Exercise>?
    var exercisesByMuscle = [String : Results<Exercise>]()
    var units = "lbs"
    var muscles = [String]()
    var selectedExerciseType = "All"
    
    var exercisesToAdd = [Exercise]()
    
    // From WorkoutVC
    var selectedWorkout: Workout?
    
    
    // MARK: Outlets
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveSelectionsButton: UIButton!
    
    // MARK: Actions
    @IBAction func newExerciseButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToNewExerciseVC", sender: self)
    }
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = selectedExerciseType + " Exercises"
        
        // Format save selections button
        saveSelectionsButton.layer.cornerRadius = 10.0
        
        
        // Set tableView delegate and datasource
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        searchBar.delegate = self
        
        
        // Register custom cells
        exerciseTableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        exerciseTableView.rowHeight = UITableView.automaticDimension
        exerciseTableView.estimatedRowHeight = 70.0
        
        
        // Load exercise data
        setupSearchBar()
        loadExercises()
        setExercisesByMuscle()
        
    }
    
    func setupSearchBar() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["All", "Main", "Variation", "Accessory", "Other"]
        searchBar.selectedScopeButtonIndex = 0
    }
    
    // MARK: Save/Load Data
    
    func loadExercises() {
        // Load all exercieses from realm
        allExercises = realm.objects(Exercise.self)
        
        // Filter exercises based on selected scope button
        if let possibleTypes = searchBar.scopeButtonTitles {
            let index = searchBar.selectedScopeButtonIndex
            if index != 0 {
                allExercises = allExercises?.filter("type == %@", possibleTypes[index])
            }
        }
        
        // Reload the tableView
        exerciseTableView.reloadData()
    }
    
    func setExercisesByMuscle() {
        if let exercises = allExercises {
            // Clear contents of muscles
            muscles = [String]()
            
            // Loop through each exercise in allExercises
            for exercise in exercises {
                // Append muscle to muscles if not already a member
                if let muscle = exercise.muscleGroup {
                    if !muscles.contains(muscle) {
                        muscles.append(muscle)
                    }
                }
            }

            // Fill exerciseByMuscle
            for muscle in muscles {
                let filteredExercises = allExercises?.filter("muscleGroup == %@", muscle).sorted(byKeyPath: "name", ascending: true)
                exercisesByMuscle[muscle] = filteredExercises
            }
            
        }
        // Reload table view
        exerciseTableView.reloadData()
    }

    func saveExerciseToSlot(exercise: Exercise) {
        do {
            try realm.write {
                let newExerciseSlot = ExerciseSlot()
                newExerciseSlot.exercise = exercise
                newExerciseSlot.number = (selectedWorkout?.exerciseSlots.count ?? 0) + 1
                selectedWorkout?.exerciseSlots.append(newExerciseSlot)
            }
        } catch {
            print("Error creating new exercise slot...\(error)")
        }
    }
    

    
    // MARK: Navigation
    
    @IBAction func unwindToExerciseBankVC(_ sender: UIStoryboardSegue) {
        loadExercises()
        setExercisesByMuscle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWorkoutVC" {
            for exercise in exercisesToAdd {
                saveExerciseToSlot(exercise: exercise)
            }
        }
    }


}

extension ExerciseBankVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return muscles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Creating header view for section
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Parameters for sizing or positioning subviews
        let topPadding = CGFloat(5.0)
        let screenWidth = UIScreen.main.bounds.width
        let labelWidth = screenWidth - 70.0
        
        // Section label subview
        let sectionLabel = UILabel()
        let fontSize = CGFloat(20)
        sectionLabel.text = muscles[section]
        sectionLabel.font = UIFont(name: "Rockwell", size: fontSize)
        sectionLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        sectionLabel.frame = CGRect(x: 10, y: topPadding, width: labelWidth, height: 35)
        headerView.addSubview(sectionLabel)
        
        // Hide button subview
        let hideButton = UIButton()
        hideButton.setTitle("Hide", for: .normal)
        hideButton.setTitleColor(.white, for: .normal)
        hideButton.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        hideButton.layer.cornerRadius = 10.0
        hideButton.frame = CGRect(x: 10 + labelWidth, y: topPadding, width: 50, height: 35)
        headerView.addSubview(hideButton)
        
        // Return header View
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Height for section header
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let muscle = muscles[section]
        return exercisesByMuscle[muscle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        let muscle = muscles[indexPath.section]
        if let exercise = exercisesByMuscle[muscle]?[indexPath.row] {
            cell.nameLabel.text = exercise.name
            var details = exercise.equipment!
            if exercise.type == "Main" {
                details += exercise.oneRepMax != 0 ? ", ORM: \(exercise.oneRepMax)\(units)" : ", ORM not entered..."
            }
            cell.detailsLabel.text = details
            
            // Add check mark to cell if exericise isSelected property is true
            cell.accessoryType = exercisesToAdd.contains{$0.name == exercise.name} ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Reference to section of table view
        let muscle = muscles[indexPath.section]
        
        // Create constant for exercise at selected row
        if let exercise = exercisesByMuscle[muscle]?[indexPath.row] {
            
            // If exercise is not in exercises to add, append it to exercises to add
            if !exercisesToAdd.contains{$0.name == exercise.name}{
                exercisesToAdd.append(exercise)
                print("added")

            
            // Otherwise remove exercise from exercises to add
            } else {
                exercisesToAdd.remove(at: exercisesToAdd.firstIndex{$0.name == exercise.name}!)
                print("removed")
            }
        }
        
        exerciseTableView.reloadData()
    }
    
}

extension ExerciseBankVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadExercises()
        // Filter exercises by text in searchbar
        allExercises = allExercises?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)

        setExercisesByMuscle()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadExercises()
            setExercisesByMuscle()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        loadExercises()
        setExercisesByMuscle()
        print(selectedScope)
        selectedExerciseType = searchBar.scopeButtonTitles?[selectedScope] ?? ""
    }
}
