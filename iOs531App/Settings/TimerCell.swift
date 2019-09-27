//
//  TimerCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/22/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol TimerCellDelegate: class {
    func stateChanged(timerLabel: String, isOn: Bool)
}

class TimerCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    weak var delegate: TimerCellDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timerSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    @IBAction func timerStateChanged(_ sender: UISwitch) {
        print("Timer state changed")
        delegate?.stateChanged(timerLabel: timerLabel.text!, isOn: sender.isOn)
        
    }
}
