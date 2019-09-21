//
//  TextFieldCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit


class TextFieldCell: UITableViewCell{

    //MARK: Outlets
    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    
    //MARK: Data
    var mainLift: Lift!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithField(mainLift: Lift, editable: Bool){
        self.mainLift = mainLift
        self.fieldValueTextField.text = "\(mainLift.day) - \(mainLift.bbbLift)"
        self.liftNameLabel.text = mainLift.name
        self.fieldValueTextField.isUserInteractionEnabled = false
        self.selectionStyle = .default
    }
    
}
