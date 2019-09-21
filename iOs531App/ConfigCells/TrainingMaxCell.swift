//
//  TrainingMaxCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol TrainingMaxCellDelegate: class {
    func maxChangedForField(mainLift: Lift, max: Double)
}

extension TrainingMaxCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let num = textField.text, let max = Double(num){
            delegate?.maxChangedForField(mainLift: mainLift, max: max)
        }
        return true
    }
}


class TrainingMaxCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var liftMaxField: UITextField!
    
    weak var delegate: TrainingMaxCellDelegate?
    var mainLift: Lift!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        liftMaxField.delegate = self
    }
    
    func configureWithField(mainLift: Lift){
        self.mainLift = mainLift
    }

}
