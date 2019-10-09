//
//  AssistanceInputCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/26/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit


class AssistanceInputCell: UITableViewCell {

    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }
}
