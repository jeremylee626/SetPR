//
//  Meal.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Meal: Object {
    
    // MARK: - Properties
    @objc dynamic var cycleNumber = 1
    @objc dynamic var dayNumber = 1
    @objc dynamic var caloriesGoal = 0
    @objc dynamic var proteinGoal = 0
    @objc dynamic var carbsGoal = 0
    @objc dynamic var fatGoal = 0
    @objc dynamic var fiberGoal = 0
    @objc dynamic var caloriesConsumed = 0
    @objc dynamic var proteinConsumed = 0
    @objc dynamic var fatConsumed = 0
    @objc dynamic var carbsConsumed = 0
    @objc dynamic var fiberConsumed = 0
    @objc dynamic var didEat = false
    
    // MARK: - Child Relationships
    var foods = List<Food>()
    
    // MARK: - Parent Relationships
    let parentDay = LinkingObjects(fromType: ProgramDay.self, property: "meals")
}

