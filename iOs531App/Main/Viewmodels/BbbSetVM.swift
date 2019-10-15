//
//  BbbSetVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/12/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class BbbSetVM: SetViewModel {
    var lift: Lift
    var weight: Double
    var isChecked: Bool
    
    init(lift: Lift, roundTo: Double, isChecked: Bool){
        self.lift = lift
        self.weight = round((0.6*lift.trainingMax)/roundTo)*roundTo
        self.isChecked = isChecked
    }
    
    func getLabel() -> String{
        return "10 reps at \(weight) lbs"
    }
    
    func getDescription() -> String{
        return "60% of your training max of \(lift.trainingMax) lbs"
    }
    
    func checked() -> Bool {
        return isChecked
    }
    
    func setChecked(checked: Bool) {
        isChecked = checked
    }
}
