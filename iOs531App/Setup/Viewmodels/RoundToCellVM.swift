//
//  RoundToCellVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/5/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class RoundToCellVM: RowViewModel, ViewModelPressible {
    let weight: Double
    var isSelected: Bool
    
    init(weight: Double, isSelected: Bool){
        self.weight = weight
        self.isSelected = isSelected
    }
}
