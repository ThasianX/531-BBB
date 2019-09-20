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
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func configureWithField(mainLift: Lift, editable: Bool){
        self.mainLift = mainLift
        self.fieldValueTextField.text = "\(mainLift.day) - \(mainLift.bbbLift)"
        self.liftNameLabel.text = mainLift.name
        self.fieldValueTextField.isUserInteractionEnabled = false
        self.selectionStyle = .default
    }
    
}
