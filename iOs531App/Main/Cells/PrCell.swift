//
//  PrCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class PrCell: UITableViewCell, SetConfigurable, AlertConfigurable {

    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var setDescription: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    
    var viewModel: MainSetVM?
    
    func setup(setViewModel: SetViewModel) {
        guard let viewModel = setViewModel as? MainSetVM else {
            return
        }
        
        self.viewModel = viewModel
        setLabel.text = viewModel.getLabel()
        setDescription.text = viewModel.getDescription()
        prLabel.text = viewModel.prLabel
        self.accessoryType = viewModel.isChecked ? .checkmark : .none
    }

}
