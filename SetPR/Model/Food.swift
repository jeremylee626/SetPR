//
//  Food.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Food : Object {
    
    // MARK: - Properties
    @objc dynamic var name: String?
    @objc dynamic var calories = 0
    @objc dynamic var fat = 0
    @objc dynamic var carbs = 0
    @objc dynamic var protein = 0
    @objc dynamic var fiber = 0
    
    // MARK: - Parent Relationships
    let parentMeal = LinkingObjects(fromType: Meal.self, property: "foods")
    
}
