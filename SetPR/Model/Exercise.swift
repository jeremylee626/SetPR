//
//  Exercise.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    
    // MARK: Properties
    @objc dynamic var name: String?
    @objc dynamic var muscleGroup: String?
    @objc dynamic var equipment: String?
    @objc dynamic var oneRepMax: Int = 0
    @objc dynamic var type: String?
   
}
