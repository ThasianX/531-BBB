//
//  AssistanceSetVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/12/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class AssistanceSetVM: SetViewModel {
    var assistance: Assistance
    var isChecked: Bool
    
    init(assistance: Assistance, isChecked: Bool){
        self.assistance = assistance
        self.isChecked = isChecked
    }
    
    func getLabel() -> String{
        return "\(assistance.reps) reps of \(assistance.name)"
    }
    
    func getDescription() -> String{
        return "Category: \(assistance.type)"
    }
    
    func checked() -> Bool {
        return isChecked
    }
    
    func setChecked(checked: Bool) {
        isChecked = checked
    }
}
