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
    @objc dynamic var repsTarget = 0
    @objc dynamic var weightTarget = 0
    @objc dynamic var repsPerformed = 0
    @objc dynamic var weightPerformed = 0
    @objc dynamic var intensity = 0
    @objc dynamic var RPE = 0
    @objc dynamic var type: String?
    @objc dynamic var isComplete = false
    @objc dynamic var rest = 0
    
    // MARK: Relationships
    let parentExercise = LinkingObjects(fromType: Exercise.self, property: "exerciseSets")
    
    // MARK: Methods
    func calculateVolume(reps: Int, weight: Int) -> Int {
        return reps * weight
    }

}
