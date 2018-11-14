//
//  CardioSet.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class CardioSet: Object {
    
    // MARK: Properties
    @objc dynamic var workoutId: String?
    @objc dynamic var number = 1
    @objc dynamic var time = 0
    @objc dynamic var distance = 0
    @objc dynamic var pace = 0
    @objc dynamic var isComplete = false
    
    // MARK: Relationships
    let parentCardioExercise = LinkingObjects(fromType: Exercise.self, property: "cardioSets")
}
