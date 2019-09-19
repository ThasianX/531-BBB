//
//  TableViewCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class ProgressionCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var progressionLiftLabel: UILabel!
    @IBOutlet weak var progressionField: UITextField!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }

}
