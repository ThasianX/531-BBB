//
//  Lift.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class Lift{

    let id: Int64?
    var name: String
    var progression: Double
    var trainingMax: Double
    var personalRecord : Int64
    var dayString : String
    var dayInt: Int64
    var bbbLiftId: Int64
    var assistanceExercisesId : Int64
    
    init(id: Int64, name: String, progression: Double, trainingMax: Double, personalRecord: Int64, dayString: String, dayInt: Int64, bbbLiftId : Int64, assistanceExercisesId : Int64) {
        self.id = id
        self.name = name
        self.progression = progression
        self.trainingMax = trainingMax
        self.personalRecord = personalRecord
        self.dayString = dayString
        self.dayInt = dayInt
        self.bbbLiftId = bbbLiftId
        self.assistanceExercisesId = assistanceExercisesId
    }
    
}
