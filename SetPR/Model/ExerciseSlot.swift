//
//  ExerciseSlot.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/14/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class ExerciseSlot: Object {
    // MARK: - Properties
    @objc dynamic var number = 1
    @objc dynamic var exercise: Exercise?
    
    // MARK: - Parent relationship
    let parentWorkout = LinkingObjects(fromType: Workout.self, property: "exerciseSlots")
    
    
}
