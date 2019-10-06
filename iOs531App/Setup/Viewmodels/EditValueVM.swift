//
//  TrainingMaxVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/5/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

protocol CellEditable {
    func updateField(index: Int, section: Int, num: Double)
}

class EditValueVM: RowViewModel {
    let liftName: String
    let index: Int
    let section: Int
    var fieldValue: Double
    
    var delegate: CellEditable?
    
    init(liftName: String, fieldValue: Double, index: Int, section: Int){
        self.liftName = liftName
        self.fieldValue = fieldValue
        self.index = index
        self.section = section
    }
    
    func updateField(index: Int, section: Int, num: Double){
        delegate?.updateField(index: index, section: section, num: num)
    }
}
