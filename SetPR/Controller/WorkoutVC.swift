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
    var workoutExercises: Results<Exercise>?
    
    // MARK: Outlets
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExerciseBankVC
        destinationVC.selectedWorkout = workout
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: "goToExerciseBank", sender: self)
    }
    
    // MARK: Load/Save Data
    
    func loadWorkoutExercises() {
        // Load exercises filtered by parent workout name
        workoutExercises = realm.objects(Exercise.self).filter("ANY parentWorkout.name == %@", workout!.name!)
        
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
        editButton.frame = CGRect(x: 10 + labelWidth, y: topPadding, width: 50, height: 35)
        headerView.addSubview(editButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workoutExercises?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == workoutExercises?.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
            cell.addButton.addTarget(self, action: #selector(WorkoutVC.addButtonPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutExerciseCell", for: indexPath) as! WorkoutExerciseCell
            
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.nameLabel.text = workoutExercises?[indexPath.row].name ?? "No exercise name specified..."
//            cell.numberLabel.layer.cornerRadius = cell.numberLabel.frame.size.width / 2
//            cell.numberLabel.layer.masksToBounds = true
            return cell
        }
    }
    

}
