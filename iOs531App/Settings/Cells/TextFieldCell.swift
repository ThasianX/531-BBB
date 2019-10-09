//
//  TextFieldCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit


class TextFieldCell: UITableViewCell, CellConfigurable{
    
    //MARK: Outlets
    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    
    //MARK: Data
    var viewModel: SchedulePickerVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? SchedulePickerVM else {
            return
        }
        
        self.viewModel = viewModel
        self.fieldValueTextField.text = "\(viewModel.lift.dayString) - BBB: \(viewModel.bbbLift)"
        self.liftNameLabel.text = viewModel.lift.name
        self.fieldValueTextField.isUserInteractionEnabled = false
        self.selectionStyle = .default
        
    }
    
}
