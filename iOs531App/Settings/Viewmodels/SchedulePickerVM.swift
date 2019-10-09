//
//  DayAndLiftPickerVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SchedulePickerVM: RowViewModel, ViewModelPressible {
    
    var lift: Lift
    var bbbLift: String
    var pickerData: [[String]]
    var indexPath: IndexPath
    
    init(lift: Lift, bbbLift: String, indexPath: IndexPath) {
        self.lift = lift
        self.bbbLift = bbbLift
        self.indexPath = indexPath
        self.pickerData = [["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], ["Overhead Press", "Deadlift", "Bench Press", "Squat"]]
    }
}
