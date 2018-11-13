//
//  ProgramDay.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/13/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class ProgramDay: Object {
    
    // MARK: - Properties
    @objc dynamic var cycleNumber = 1
    @objc dynamic var dayNumber = 1
    @objc dynamic var date: Date?
    
    // MARK: - Child relationships
    var workouts = List<Workout>()
    var meals = List<Meal>()
    @objc dynamic var sleep: SleepPlan?

    // MARK: - Parent relationships
    var parentProgram = LinkingObjects(fromType: Program.self, property: "days")
}
