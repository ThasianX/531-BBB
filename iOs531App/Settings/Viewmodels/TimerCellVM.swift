//
//  TimerCellVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class TimerCellVM: RowViewModel {
    var timerLabel: String
    var isOn: Bool
    
    init(timerLabel: String, isOn: Bool) {
        self.timerLabel = timerLabel
        self.isOn = isOn
    }
}
