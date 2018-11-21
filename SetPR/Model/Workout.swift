//
//  Workout.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift


class Workout: Object {
    // MARK: Properties
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var cycleNumber: Int = 0
    @objc dynamic var dayNumber: Int = 0
    @objc dynamic var isComplete = false
    @objc dynamic var isActive = false
    @objc dynamic var dateCompleted: Date?
    @objc dynamic var quality: Int = 3
    
    // MARK: Child relationship
    var exerciseSlots = List<ExerciseSlot>()
    var muscles = List<String>()
    
    // MARK: Parent Class
    let parentDay = LinkingObjects(fromType: ProgramDay.self, property: "workouts")
    
    // MARK: Primary Key
    override static func primaryKey() -> String? {
        return "id"
    }
}
