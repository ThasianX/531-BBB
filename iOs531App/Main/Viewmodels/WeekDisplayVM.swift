//
//  WeekDisplayVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/10/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class WeekDisplayVM: RowViewModel {
    var week: String
    var percentages: String
    var progress: Float
    
    init(week: String, percentages: String, progress: Float){
        self.week = week
        self.percentages = percentages
        self.progress = progress
    }
}
