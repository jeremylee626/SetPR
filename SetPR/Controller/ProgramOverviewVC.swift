//
//  ProgramOverviewVC.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramOverviewVC: UIViewController {
    
    let realm = try! Realm()
    
    // MARK: - Variables
    var user: User?
    var programs: Results<Program>?
    var selectedProgram: Program?
    
    
    // MARK: - Outlets
    @IBOutlet weak var programTableView: UITableView!
    
    // MARK: - Actions
    @IBAction func newProgramButtonPressed(_ sender: UIBarButtonItem) {
        // Create an alert window
        let alert = UIAlertController(title: "Create New Program", message: "Enter new program details", preferredStyle: .alert)
        
        // Create textfields for user input
        var nameTextField = UITextField()
        var weeksTextfield = UITextField()
        var goalsTextField = UITextField()
        
        
        // Action for creating new program
        let create = UIAlertAction(title: "Create", style: .default) { (create) in
            // Create a new program
            let newProgram = Program()
            newProgram.name = nameTextField.text
            newProgram.numberOfCycles = Int(weeksTextfield.text ?? "0") ?? 0
            newProgram.goal = goalsTextField.text
            self.saveNewProgram(program: newProgram)
            
            // Reload programs and tableView
            self.loadPrograms()
            self.programTableView.reloadData()
        }
        
        // Action for cancelling
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add text fields to alert window
        alert.addTextField { (alertNameTextField) in
            alertNameTextField.placeholder = "Enter program name"
            alertNameTextField.keyboardType = .default
            nameTextField = alertNameTextField
        }
        alert.addTextField { (alertWeeksTextField) in
            alertWeeksTextField.placeholder = "Enter number of weeks"
            alertWeeksTextField.keyboardType = .numberPad
            weeksTextfield = alertWeeksTextField
        }
        alert.addTextField { (alertGoalsTextField) in
            alertGoalsTextField.placeholder = "Select a goal"
            alertGoalsTextField.textAlignment = .center
            alertGoalsTextField.keyboardType = .default
            goalsTextField = alertGoalsTextField
        }
        
        // Add actions to alert window
        alert.addAction(create)
        alert.addAction(cancel)
        
        // Present alert window
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set screen title
        navigationController?.navigationBar.prefersLargeTitles =  true
//        navigationItem.title = (user?.name ?? "Error") + "'s" + "Programs"
        navigationItem.title = "Available Programs"
        
        // Set table view delegate and data source
        programTableView.delegate = self
        programTableView.dataSource = self
        
        // Register custom table view cell
        programTableView.register(UINib(nibName: "ProgramOverviewCell", bundle: nil), forCellReuseIdentifier: "ProgramOverviewCell")
        
        loadPrograms()
    }
    
    // MARK: Load/Save Data
    func loadPrograms() {
        programs = realm.objects(Program.self)
    }
    
    func saveNewProgram(program: Program) {
        // Try to save input program to realm
        do {
            try realm.write {
                realm.add(program)
            }
        } catch {
            print("Error saving program...\(error)")
        }
    }
    
    // MARK: - Navigation
    @objc func editButtonPressed(_ sender: UIButton) {
        if let programs = programs {
            selectedProgram = programs[sender.tag]
            performSegue(withIdentifier: "goToSelectedProgramVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelectedProgramVC
        destinationVC.selectedProgram = selectedProgram
    }

}


// MARK: - Extensions
extension ProgramOverviewVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return programs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        if let programs = programs {
            // Set label text to name of program
            sectionLabel.text = programs[section].name
        }
        sectionLabel.font = UIFont(name: "Rockwell", size: fontSize)
        sectionLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        sectionLabel.frame = CGRect(x: 10, y: topPadding, width: labelWidth, height: 35)
        headerView.addSubview(sectionLabel)
        
        // Hide button subview
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        editButton.layer.cornerRadius = 10.0
        editButton.frame = CGRect(x: 10 + labelWidth, y: topPadding, width: 50, height: 35)
        editButton.addTarget(self, action: #selector(ProgramOverviewVC.editButtonPressed(_:)), for: .touchUpInside)
        editButton.tag = section
        headerView.addSubview(editButton)
        
        // Return header View
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramOverviewCell", for: indexPath) as! ProgramOverviewCell
        
        if let loadedPrograms = programs {
            // Set cell labels and add target to activate button
            cell.weeksNoLabel.text = "\(loadedPrograms[indexPath.section].numberOfCycles)"
            cell.startDateLabel.text = "TBD"
            cell.endDateLabel.text = "TBD"
            cell.activateButton.addTarget(self, action: #selector(ProgramOverviewVC.activateButtonPressed(_:)), for: .touchUpInside)
            
            // Set a tag for activate button
            cell.activateButton.tag = indexPath.section
            
            // Configure activate button based on isActive property
            if loadedPrograms[indexPath.section].isActive {
                cell.activateButton.setTitle("Finish", for: .normal)
                cell.activateButton.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            } else {
                cell.activateButton.setTitle("Activate", for: .normal)
                cell.activateButton.backgroundColor = #colorLiteral(red: 0.5692999382, green: 1, blue: 0.6264482415, alpha: 1)
            }
        }
        return cell
    }
    
    @objc func activateButtonPressed(_ sender: UIButton) {
        if let programs = programs {
            do {
                try realm.write {
                    // Flip selected program's isActive property
                    programs[sender.tag].isActive = !programs[sender.tag].isActive
                    
                    // If user activates a program, deactivate all other programs
                    if programs[sender.tag].isActive {
                        for index in 0..<programs.count {
                            if index != sender.tag {
                                programs[index].isActive = false
                            }
                        }
                    }
                }
                // Reload the table view
                programTableView.reloadData()
            } catch {
                print("Unable to update program status")
            }
        }
    }
}
