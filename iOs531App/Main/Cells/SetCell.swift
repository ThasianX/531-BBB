//
//  SetCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell, SetConfigurable {
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var setDescription: UILabel!
    
    var viewModel: SetViewModel?
    
    func setup(setViewModel: SetViewModel) {
        self.viewModel = setViewModel
        setLabel.text = viewModel?.getLabel()
        setDescription.text = viewModel?.getDescription()
        self.accessoryType = viewModel!.checked() ? .checkmark : .none
    }
}
