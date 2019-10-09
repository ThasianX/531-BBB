//
//  LiftGenerator.swift
//  iOs531App
//
//  Created by Kevin Li on 10/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SetupData {
    
    static func generateLifts() -> [Lift] {
        var lifts = [Lift]()
        
        lifts.append(Lift(id: 0, name: "Overhead Press", progression: 5.0, trainingMax: 0.0, personalRecord: 0, dayString: "Monday", dayInt: 1, bbbLiftId: 0))
        
        lifts.append(Lift(id: 1, name: "Deadlift", progression: 10.0, trainingMax: 0.0, personalRecord: 0, dayString: "Tuesday", dayInt: 2, bbbLiftId: 1))
        
        lifts.append(Lift(id: 2, name: "Bench Press", progression: 5.0, trainingMax: 0.0, personalRecord: 0, dayString: "Wednesday", dayInt: 3, bbbLiftId: 2))
        
        lifts.append(Lift(id: 3, name: "Squat", progression: 10.0, trainingMax: 0.0, personalRecord: 0, dayString: "Friday", dayInt: 5, bbbLiftId: 3))
        
        return lifts
    }
}
