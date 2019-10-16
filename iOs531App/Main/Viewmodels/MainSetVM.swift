//
//  MainSetVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/12/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class MainSetVM: SetViewModel {
    
    var lift: Lift
    var weight: Double
    var reps: Int
    var percentage: Double
    var isChecked: Bool
    var prLabel: String
    
    init(lift: Lift, roundTo: Double, reps: Int, percentage: Double, isChecked: Bool, prLabel: String){
        self.lift = lift
        self.weight = round((percentage*lift.trainingMax)/roundTo)*roundTo
        self.reps = reps
        self.percentage = percentage
        self.isChecked = isChecked
        self.prLabel = prLabel
    }
    
    func getLabel() -> String{
        return "\(reps) reps at \(weight) lbs"
    }
    
    func getDescription() -> String{
        return "\(Int(percentage*100.0))% of your training max of \(lift.trainingMax) lbs"
    }
    
    func checked() -> Bool {
        return isChecked
    }
    
    func setChecked(checked: Bool) {
        isChecked = checked
    }
    
}
