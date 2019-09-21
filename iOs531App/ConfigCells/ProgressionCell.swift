//
//  TableViewCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol ProgressionCellDelegate: class {
    func progressionChangedForField(mainLift: Lift, progression: Double)
}

extension ProgressionCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Text field done editing")
        if let num = textField.text, let progression = Double(num){
            delegate?.progressionChangedForField(mainLift: mainLift, progression: progression)
        }
        return true
    }
}

class ProgressionCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var progressionLiftLabel: UILabel!
    @IBOutlet weak var progressionField: UITextField!
    
    weak var delegate: ProgressionCellDelegate?
    var mainLift: Lift!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressionField.delegate = self
    }
    
    func configureWithField(mainLift: Lift){
        self.mainLift = mainLift
    }

}

