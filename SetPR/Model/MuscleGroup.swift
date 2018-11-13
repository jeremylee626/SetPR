//
//  MuscleGroup.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class MuscleGroup: Object {
    
    // MARK: Properties
    @objc dynamic var name: String?
    @objc dynamic var lastTrainingDate: Date?
    
    // MARK: Relationships
    let exercises = List<Exercise>()
}
