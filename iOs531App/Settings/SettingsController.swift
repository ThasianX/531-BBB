//
//  SettingsController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, TextFieldCellDelegate, DayAndLiftPickerCellDelegate {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Data
    let mainLifts = ["Overhead Press", "Deadlift", "Bench Press", "Squat"]
    let roundValues : [Double] = [2.5, 5, 10]
    
    var chosenRoundTo = 2.5
    var lifts : [Lift] = []
    
    //datepicker related data
    var pickerIndexPath: IndexPath?
    var pickerVisible: Bool {
        return pickerIndexPath != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        lifts = UserDefaults.standard.value(forKey: "lifts") as! [Lift]
    }
    
    
    //MARK: Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if picker is visible, add one to the list of lifts for row count
        return pickerVisible ? mainLifts.count + 1 : mainLifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //date picker
        if pickerVisible && pickerIndexPath! == indexPath{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "dayAndLiftPickerCell", for: indexPath) as! DayAndLiftPickerCell
            
            //lift will correspond to the index of the row before this one
            let lift = mainLifts[indexPath.row-1]
            cell.configureWithField(mainLift: lift, currentDay: <#T##String#>)
            return cell
            
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !pickerShouldAppearAtRowForSelectionAtIndexPath(indexPath: indexPath) {
            dismissPickerRow()
            return
        }
        
        self.view.endEditing(true)
        //used for animating the deletion of rows inbetween
        tableView.beginUpdates()
        
        if pickerVisible {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            let oldPickerIndexPath = pickerIndexPath!
            
            if pickerIsRightBelowMe(indexPath: indexPath) {
                //close the picker
                pickerIndexPath = nil
            } else {
                //open picker in new location
                let newRow = oldPickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                pickerIndexPath = IndexPath(row: newRow, section: indexPath.section)
                tableView.insertRows(at: [pickerIndexPath!], with: .fade)
            }
        } else {
            pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [pickerIndexPath!], with: .fade)
        }
        tableView.endUpdates()
    }
    
    //MARK: Helper methods
    func calculateLiftForIndexPath(indexPath: IndexPath) -> String {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if pickerIndexPath!.row == indexPath.row {
                //picker row matches current indexpath row, so return the lift above this cell
                return mainLifts[indexPath.row - 1]
            } else if pickerIndexPath!.row > indexPath.row {
                //current indexpath row is below the picker so it's safe to just return the lift at the current cell
                return mainLifts[indexPath.row]
            } else {
                //current indexpath row is above the picker so return the lift above this row
                return mainLifts[indexPath.row - 1]
            }
        } else {
            //since the picker isn't showing, just return the current lift at cell
            return mainLifts[indexPath.row]
        }
    }
    
    func pickerShouldAppearAtRowForSelectionAtIndexPath(indexPath : IndexPath) -> Bool{
        //probably going to use indexpath.section later to determine whether to use it or not
        return true
    }
    
    func dismissPickerRow() {
        if !pickerVisible {
            return
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
        pickerIndexPath = nil
        tableView.endUpdates()
    }
    
    func pickerIsRightBelowMe(indexPath: IndexPath) -> Bool{
        if pickerVisible && pickerIndexPath!.section == indexPath.section{
            return indexPath.row == pickerIndexPath!.row - 1
        } else {
            return false
        }
    }
    
    func pickerIsRightAboveMe(indexPath: IndexPath) -> Bool{
        if pickerVisible && pickerIndexPath!.section == indexPath.section{
            return indexPath.row == pickerIndexPath!.row + 1
        } else {
            return false
        }
    }
    
    //MARK: DayAndLiftPickerCellDelegate methods
    
    func dayChangedForField(mainLift: String, toDay day: String) {
        print("Day changed for \(mainLift) to \(day)")
        
    }
    
    func liftChangedForField(mainLift: String, toLift lift: String) {
        <#code#>
    }
    
    //MARK: TextFieldCellDelegate methods
    
    func fieldDidBeginEditing(mainLift: String) {
        <#code#>
    }
    
    func field(mainLift: String, changedValueTo value: String) {
        <#code#>
    }
}
