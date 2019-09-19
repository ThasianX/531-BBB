//
//  TextFieldCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func fieldDidBeginEditing(mainLift: String)
    func field(mainLift: String, changedValueTo value: String)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    
    //MARK: Data
    var mainLift: String!
    weak var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldValueTextField.delegate = self
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        self.delegate?.field(mainLift: mainLift, changedValueTo: sender.text ?? "")
    }
    
    func configureWithField(mainLift: String, andValue value: String?, editable: Bool){
        self.mainLift = mainLift
        self.fieldValueTextField.text = value ?? ""
        self.liftNameLabel.text = mainLift
        
        if editable {
            self.fieldValueTextField.isUserInteractionEnabled = true
            self.selectionStyle = .none
        } else {
            self.fieldValueTextField.isUserInteractionEnabled = false
            self.selectionStyle = .default
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.fieldDidBeginEditing(mainLift: mainLift)
    }
    
}
