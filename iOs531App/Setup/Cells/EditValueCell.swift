//
//  EditValueCell.swift
//  iOs531App
//
//  Created by Kevin Li on 10/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit


protocol EditValueCellDelegate: class {
    func valueChangedForField(index: Int, section: Int, value: Double)
}

extension EditValueCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        log.info("Text field done editing")
        if let num = textField.text, let value = Double(num){
            delegate?.valueChangedForField(index: index, section: section, value: value)
        }
        return true
    }
}

class EditValueCell: UITableViewCell, CellConfigurable {
    
    //MARK: Outlets
    @IBOutlet weak var liftName: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    
    //MARK: Properties
    weak var delegate: EditValueCellDelegate?
    var index: Int!
    var section: Int!
    var viewModel: EditValueVM?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editTextField.delegate = self
    }
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? EditValueVM else {
            return
        }
        
        self.viewModel = viewModel
        
        self.liftName.text = viewModel.liftName
        self.editTextField.placeholder = "\(viewModel.fieldValue) lb"
        self.index = viewModel.index
        self.section = viewModel.section
    }
    
    func updateField(num: Double){
        log.debug("Cell field being updated. Placeholder should be \(num) lb")
        self.editTextField.placeholder = "\(num) lb"
        self.editTextField.text = ""
    }
}

