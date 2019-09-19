//
//  DateAndLiftPickerCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/18/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol DayAndLiftPickerCellDelegate: class {
    func dayChangedForField(mainLift: String, toDay day: String)
    func liftChangedForField(mainLift: String, toLift lift: String)
}

class DayAndLiftPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var dayAndLiftPicker: UIPickerView!
    
    //MARK: Data
    var mainLift: String!
    weak var delegate: DayAndLiftPickerCellDelegate?
    var pickerData: [[String]] = [[String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayAndLiftPicker.delegate = self
        dayAndLiftPicker.dataSource = self
        pickerData = [["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], ["Overhead Press", "Deadlift", "Bench Press", "Squat"]]
    }

    func configureWithField(mainLift: String, currentDay: String){
        self.mainLift = mainLift
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component==0 {
            self.delegate?.dayChangedForField(mainLift: mainLift, toDay: pickerData[component][row])
        } else if component==1 {
            self.delegate?.liftChangedForField(mainLift: mainLift, toLift: pickerData[component][row])
        }
    }

}
