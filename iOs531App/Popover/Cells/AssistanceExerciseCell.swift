//
//  AssistanceExerciseCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/26/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class AssistanceExerciseCell: UITableViewCell, CellConfigurable{

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: AssistanceExerciseCellVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? AssistanceExerciseCellVM else {
            return
        }
        
        self.viewModel = viewModel
        exerciseLabel.text = viewModel.assistance.name
        descriptionLabel.text = "\(viewModel.assistance.type): \(viewModel.assistance.sets) sets x \(viewModel.assistance.reps) reps"
        
        
        self.accessoryType = (viewModel.isChecked) ? .checkmark : .none
    }
}
