//
//  WeekDisplayCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class WeekDisplayCell: UICollectionViewCell, CellConfigurable {

    //MARK: Outlets
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var trainingPercentagesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    
    var viewModel: WeekDisplayVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? WeekDisplayVM else {
            return
        }
        
        self.viewModel = viewModel
        weekLabel.text = viewModel.week
        trainingPercentagesLabel.text = viewModel.percentages
        progressView.setProgress(viewModel.progress, animated: true)
        progressViewLabel.text = "\(Int(100*viewModel.progress))% complete"
    }

}
