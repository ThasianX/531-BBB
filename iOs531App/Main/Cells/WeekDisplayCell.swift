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
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.layer.cornerRadius = 10.0
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
//
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 6.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
//        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor

        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }

}
