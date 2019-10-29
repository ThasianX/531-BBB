//
//  AssistanceExerciseCellVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class AssistanceExerciseCellVM: RowViewModel {
    let assistance: Assistance
    var isChecked: Bool
    
    init(assistance: Assistance, isChecked: Bool) {
        self.assistance = assistance
        self.isChecked = isChecked
    }
}
