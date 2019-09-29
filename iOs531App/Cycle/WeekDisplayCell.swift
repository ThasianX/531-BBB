//
//  WeekDisplayCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class WeekDisplayCell: UICollectionViewCell {

    //MARK: Outlets
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var trainingPercentagesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Use userdefaults to get the number of rows checked and divide that by the total number of rows to get the progress for the progress view.
    }


}
