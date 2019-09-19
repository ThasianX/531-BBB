//
//  TrainingMaxCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class TrainingMaxCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var liftMaxField: UITextField!
    
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }

}
