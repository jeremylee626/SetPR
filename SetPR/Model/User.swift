//
//  User.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift


class User: Object {
    
    // MARK: - Properties
    @objc dynamic var name: String?
    @objc dynamic var birthDate: Date?
    @objc dynamic var height = 65
    @objc dynamic var weight = 158.4
    
    // MARK: - Relationships
//    var programs = List<Program>()
}
