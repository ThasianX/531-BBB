//
//  EditTextCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
//
//protocol AssistanceCellDelegate: class {
//    func assistanceChangedForField(mainLift: Lift, assistance: Double)
//}
//
//extension AssistanceCell: UITextFieldDelegate {
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("Text field done editing")
//        if let num = textField.text, let progression = Double(num){
//            delegate?.progressionChangedForField(mainLift: mainLift, progression: progression)
//        }
//        return true
//    }
//}

class AssistanceCell: UITableViewCell {

    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var assistanceLabel: UILabel!
    
}
