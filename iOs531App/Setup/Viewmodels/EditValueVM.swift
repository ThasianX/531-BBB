//
//  TrainingMaxVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/5/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
class EditValueVM: RowViewModel {
    let liftName: String
    let index: Int
    let section: Int
    var fieldValue: Double
    
    init(liftName: String, fieldValue: Double, index: Int, section: Int){
        self.liftName = liftName
        self.fieldValue = fieldValue
        self.index = index
        self.section = section
    }
    
}
