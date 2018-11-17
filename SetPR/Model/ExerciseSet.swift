//
//  ExerciseSet.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class ExerciseSet: Object {
    
    // MARK: Properties
    @objc dynamic var number = 1
    @objc dynamic var type: String?
    @objc dynamic var isActive = false
    @objc dynamic var isComplete = false
    
    
    // Goals
    @objc dynamic var repsTarget = 0
    @objc dynamic var weightTarget = 0
    @objc dynamic var intensityTarget = 0.0
    
    // Actual
    @objc dynamic var repsPerformed = 0
    @objc dynamic var weightPerformed = 0
    @objc dynamic var intensityPerformed = 0.0
    @objc dynamic var rest = 0
    
    // MARK: Relationships
    let parentExerciseSlot = LinkingObjects(fromType: ExerciseSlot.self, property: "exerciseSets")
    

}
