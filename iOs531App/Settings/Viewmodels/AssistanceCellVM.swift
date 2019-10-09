//
//  AssistanceCellVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class AssistanceCellVM: RowViewModel {
    
    var liftName: String
    var assistanceExercises: String
    var index: Int
    
    init(liftName: String, assistanceExercises: String, index: Int) {
        self.liftName = liftName
        self.assistanceExercises = assistanceExercises
        self.index = index
    }
}
