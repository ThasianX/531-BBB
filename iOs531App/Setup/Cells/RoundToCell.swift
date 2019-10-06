//
//  RoundToCellTableViewCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/13/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class RoundToCell: UITableViewCell, CellConfigurable {
    
    //MARK: Properties
    @IBOutlet weak var weightLabel: UILabel!
    
    //MARK: Viewmodel
    var viewModel: RoundToCellVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? RoundToCellVM else {
            return
        }
        
        self.viewModel = viewModel
        self.weightLabel?.text = "\(viewModel.weight) lb"
        
        if viewModel.isSelected{
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
    }
    
    
}
