//
//  SelectedProgramVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/10/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class SelectedProgramVC: UIViewController {
    
    let realm = try! Realm()
    
    // MARK: Variables
    var selectedProgram: Program?
    var days: Results<ProgramDay>?
    var programDict = [Int : Results<ProgramDay>]()
    
    var selectedWorkout: Workout?
    
    // MARK: - Outlets
    @IBOutlet weak var programTableView: UITableView!
    
    // MARK: - Actions
    @IBAction func addWeekButtonPressed(_ sender: UIBarButtonItem) {
        if let program = selectedProgram {
            // Increment program cycles by 1
            do {
                try realm.write {
                    program.numberOfCycles += 1
                    loadProgramDays()
                    programTableView.reloadData()
                }
            } catch {
                print("Error creating new cycle...\(error)")
            }
        }
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set screen title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = selectedProgram?.name ?? "Program Name"
        
        // Set table view delegate and data source
        programTableView.delegate = self
        programTableView.dataSource = self
        
        // Register custom cell in table view
        programTableView.register(UINib(nibName: "ProgramCell", bundle: nil), forCellReuseIdentifier: "ProgramCell")
        programTableView.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "AddCell")
        programTableView.rowHeight = UITableView.automaticDimension
        programTableView.estimatedRowHeight = 90
        
        // Load program days data
        loadProgramDays()
    }
    
    // MARK: - Load/Save data
    func loadProgramDays() {
        if let program = selectedProgram {
            // Load days for selected program into days variable
            days = realm.objects(ProgramDay.self).filter("ANY parentProgram.name == %@", program.name!).sorted(byKeyPath: "cycleNumber", ascending: true)
            
            // Transfer data to programDict where key is cycle number
            for cycleNum in 1...program.numberOfCycles {
                programDict[cycleNum] = days?.filter("cycleNumber == %@", cycleNum).sorted(byKeyPath: "dayNumber", ascending: true)
            }
        }
    }
    
    func saveDay(day: ProgramDay) {
        // Try to save new day to realm
        do {
            try realm.write {
                realm.add(day)
            }
        } catch {
            print("Error saving day...\(error)")
        }
    }
    
    
    // MARK: - Navigation
    @objc func workoutButtonPressed(_ sender: CustomCellButton) {
        print("Section: \(sender.section ?? 0), Row: \(sender.row ?? 0)")
        if let selectedDay = programDict[sender.section! + 1]?[sender.row!] {
            // Check if selected day does not already have a workout
            if selectedDay.workouts.count == 0 {
                // Create alert
                let alert = UIAlertController(title: "Create New Workout", message: "", preferredStyle: .alert)

                // Workout name text field
                var nameTextField = UITextField()

                // Create alert action
                let create = UIAlertAction(title: "Create", style: .default) {(create) in
                    do {
                        try self.realm.write {
                            // Create new workout object
                            let newWorkout = Workout()
                            // Set new workout properties
                            newWorkout.name = nameTextField.text
                            newWorkout.cycleNumber = sender.section! + 1
                            newWorkout.dayNumber = sender.row! + 1
                            
                            // Set primary key for new workout
                            newWorkout.id = "\(self.selectedProgram?.name ?? "Error")W\(sender.section! + 1)D\(sender.row! + 1)"
                            
                            // Append new workout to selected day's workouts
                            selectedDay.workouts.append(newWorkout)
                            
                            // Add new workout to realm
                            self.realm.add(newWorkout)

                            // Set selectedWorkout to new workout
                            self.selectedWorkout = newWorkout
                        }
                    } catch {
                        print("Error creating workout...\(error)")
                    }
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addTextField { (alertNameTextField) in
                    alertNameTextField.placeholder = "Enter new workout name"
                    nameTextField = alertNameTextField
                }
                alert.addAction(create)
                alert.addAction(cancel)
                
                present(alert, animated: true, completion: nil)
                
            } else {
                selectedWorkout = selectedDay.workouts[0]
            }

            // Go to WorkoutsVC
            performSegue(withIdentifier: "goToWorkoutVC", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WorkoutVC
        destinationVC.workout = selectedWorkout
    }


}

extension SelectedProgramVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedProgram?.numberOfCycles ?? 1
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
        title.text = " Week \(section + 1)"
        title.font = UIFont(name: "Rockwell", size: textSize)
        title.frame = CGRect(x: 0, y: topPadding, width: labelWidth, height: 35)
        headerView.addSubview(title)
        
        
        let editButton = UIButton()
        editButton.setTitle("Hide", for: .normal)
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
            addItemView.addItemButton.setTitle("+ Add Day", for: .normal)
            addItemView.addItemButton.tag = section + 1
            addItemView.addItemButton.addTarget(self, action: #selector(SelectedProgramVC.addDayButtonPressed(_:)), for: .touchUpInside)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programDict[section + 1]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create program cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
        cell.dayLabel.text = "\(programDict[indexPath.section + 1]?[indexPath.row].dayNumber ?? 0)"
        cell.workoutButton.addTarget(self, action: #selector(SelectedProgramVC.workoutButtonPressed(_:)), for: .touchUpInside)
        cell.workoutButton.row = indexPath.row
        cell.workoutButton.section = indexPath.section

        return cell
    }
    
    @objc func addDayButtonPressed(_ sender: UIButton) {
        if let program = selectedProgram {
            do {
                try realm.write {
                    // Create new program day object
                    let newDay = ProgramDay()
                    newDay.cycleNumber = sender.tag
                    newDay.dayNumber = (programDict[sender.tag]?.count ?? 0) + 1
                    program.days.append(newDay)
                    
                    // Reload program days
                    loadProgramDays()
                    
                    // Insert new cell in table view
                    let indexPath = IndexPath(row: newDay.dayNumber - 1, section: sender.tag - 1)
                    programTableView.insertRows(at: [indexPath], with: .automatic)
                }
            } catch {
                print("Error creating new program day...\(error)")
            }
        }
    }
}

