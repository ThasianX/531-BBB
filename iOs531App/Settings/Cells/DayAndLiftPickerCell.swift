//
//  DateAndLiftPickerCell.swift
//  iOs531App
//
//  Created by Kevin Li on 9/18/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol DayAndLiftPickerCellDelegate: class {
    func dayChangedForField(indexPath: IndexPath, to day: String)
    func bbbLiftChangedForField(indexPath: IndexPath, to bbbLift: String)
}

class DayAndLiftPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, CellConfigurable {
    
    //MARK: Outlets
    @IBOutlet var dayAndLiftPicker: UIPickerView!
    
    //MARK: Data
    weak var delegate: DayAndLiftPickerCellDelegate?
    var viewModel: SchedulePickerVM?
    
    func setup(viewModel: RowViewModel) {
        
        dayAndLiftPicker.delegate = self
        dayAndLiftPicker.dataSource = self
        
        guard let viewModel = viewModel as? SchedulePickerVM else {
            return
        }
        
        self.viewModel = viewModel
        
        let dayIndex = viewModel.pickerData[0].firstIndex(of: viewModel.lift.dayString)
        self.dayAndLiftPicker.selectRow(dayIndex!, inComponent: 0, animated: true)
        let liftIndex = viewModel.pickerData[1].firstIndex(of: viewModel.bbbLift)
        self.dayAndLiftPicker.selectRow(liftIndex!, inComponent: 1, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel!.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel!.pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel!.pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component==0 {
            self.delegate?.dayChangedForField(indexPath: viewModel!.indexPath, to: viewModel!.pickerData[component][row])
        } else if component==1 {
            self.delegate?.bbbLiftChangedForField(indexPath: viewModel!.indexPath, to: viewModel!.pickerData[component][row])
        }
    }

}
