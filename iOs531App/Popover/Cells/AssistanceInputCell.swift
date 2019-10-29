//
//  AssistanceInputCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/26/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class AssistanceInputCell: UITableViewCell, CellConfigurable {

    @IBOutlet weak var editTextField: UITextField!
    
    var viewModel: AssistanceInputCellVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? AssistanceInputCellVM else {
            return
        }
        
        selectionStyle = .none
        
        self.viewModel = viewModel
        
        self.editTextField.placeholder = viewModel.inputLabel
        self.editTextField.keyboardType = (viewModel.inputLabel=="Name" || viewModel.inputLabel=="Type") ? .alphabet : .numberPad
        
    }
}
