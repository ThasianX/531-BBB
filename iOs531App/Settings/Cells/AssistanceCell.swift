//
//  EditTextCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class AssistanceCell: UITableViewCell, CellConfigurable {

    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var assistanceLabel: UILabel!
    
    var viewModel: AssistanceCellVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? AssistanceCellVM else {
            return
        }
        
        self.viewModel = viewModel
        
        self.liftLabel.text = viewModel.liftName
        self.assistanceLabel.text = viewModel.assistanceExercises
        
    }
    
}
