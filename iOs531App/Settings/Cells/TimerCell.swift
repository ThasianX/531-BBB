//
//  TimerCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/22/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol TimerCellDelegate {
    func stateChanged(timerLabel: String, isOn: Bool)
}

class TimerCell: UITableViewCell, CellConfigurable {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    var delegate: TimerCellDelegate?
    
    var viewModel: TimerCellVM?
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? TimerCellVM else {
            return
        }
        
        self.viewModel = viewModel
        self.timerLabel.text = viewModel.timerLabel
        self.timerSwitch.isOn = viewModel.isOn
        
        selectionStyle = .none
        timerSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        timerSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//    }
    
    @IBAction func timerStateChanged(_ sender: UISwitch) {
        log.info("Timer stated changed. State changed function being called.")
        delegate?.stateChanged(timerLabel: timerLabel.text!, isOn: sender.isOn)
    }
}
