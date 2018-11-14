//
//  Program.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Program: Object {
    
    // MARK: - Properties
    @objc dynamic var name: String?
    @objc dynamic var isActive = false
    @objc dynamic var isComplete = false
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?
    @objc dynamic var numberOfCycles = 6
    @objc dynamic var goal: String?
    
    // MARK: - Child Relationships
    var days = List<ProgramDay>()
    
    // MARK: - Primary key
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
