//
//  DateAndLiftPickerCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/18/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol DayAndLiftPickerCellDelegate: class {
    func dayChangedForField(mainLift: Lift, toDay day: String)
    func liftChangedForField(mainLift: Lift, toLift lift: String)
}

class DayAndLiftPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var dayAndLiftPicker: UIPickerView!
    
    //MARK: Data
    var mainLift: Lift!
    weak var delegate: DayAndLiftPickerCellDelegate?
    var pickerData: [[String]] = [[String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayAndLiftPicker.delegate = self
        dayAndLiftPicker.dataSource = self
        pickerData = [["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], ["Overhead Press", "Deadlift", "Bench Press", "Squat"]]
    }

    func configureWithField(mainLift: Lift){
        self.mainLift = mainLift
        //use mainlift to set picker values
        let dayIndex = pickerData[0].firstIndex(of: mainLift.day)
        self.dayAndLiftPicker.selectRow(dayIndex!, inComponent: 0, animated: true)
        let liftIndex = pickerData[1].firstIndex(of: mainLift.bbbLift)
        self.dayAndLiftPicker.selectRow(liftIndex!, inComponent: 1, animated: true)
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
            print("Selected row at \(row). Day changed to \(pickerData[component][row])")
            self.delegate?.dayChangedForField(mainLift: mainLift, toDay: pickerData[component][row])
        } else if component==1 {
            print("Selected row at \(row). BBB lift changed to \(pickerData[component][row])")
            self.delegate?.liftChangedForField(mainLift: mainLift, toLift: pickerData[component][row])
        }
    }

}
