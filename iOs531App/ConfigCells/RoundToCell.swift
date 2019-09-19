//
//  RoundToCellTableViewCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/13/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class RoundToCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var weightLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }

}
