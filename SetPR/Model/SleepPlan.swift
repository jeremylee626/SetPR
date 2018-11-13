//
//  SleepPlan.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import Foundation
import RealmSwift

class SleepPlan: Object {
    
    // MARK: - Propterties
    @objc dynamic var plannedBedTime: Date?
    @objc dynamic var plannedWakeUpTime: Date?
    @objc dynamic var actualBedTime: Date?
    @objc dynamic var actualWakeUpTime: Date?
    @objc dynamic var targetHrsSleep = 0
    @objc dynamic var actualHrsSleep = 0
    
}
