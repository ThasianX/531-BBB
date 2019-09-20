//
//  SettingsController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, DayAndLiftPickerCellDelegate {
    
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
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.value(forKey: "lifts") as? Data {
            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
                lifts = decodedData
            }
        }

    }

    //MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if picker is visible, add one to the list of lifts for row count
        return pickerVisible ? lifts.count + 1 : lifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*We are setting up the appearance of cells in the table now. If there is a picker visible, which means a row that supports a picker must've been selected
         before remaking specific rows of the table, and the current index of that picker is the same as the current index of the table, then a new cell is created
         with the dayAndLiftPickerCell prototype. The cell is populated using data obtained from the parent cell, or the cell above, that opened it.
        */
        if pickerVisible && pickerIndexPath! == indexPath{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "dayAndLiftPickerCell") as! DayAndLiftPickerCell
            cell.delegate = self
            
            let lift = lifts[indexPath.row-1]
            cell.configureWithField(mainLift: lift)
            return cell
        } else {
            /*Since the if clause wasn't executed, there can only be two reasons why: the picker index is nil or there is a picker index but it doesn't match the current
             index of the table. If the picker index is nil, then there can only be two reasons why: no rows have been selected yet or a row was previously selected but
             it wasn't a row that supported pickers. In either case, the cell at the current table index will be using the textFieldCell prototype. Then, the cell will be
             populated using data from the current lift at the cell.
             
             The other case is if the index of the picker is not the same as the current index. This would mean that
             for this cell at this row, we would want to use the textFieldCell prototype. Knowing this, the question now is how do we determine the correct lift to populate
             the data of the cell. To do so, a helper method, calculateLiftForIndexPath, is employed. The function is general so it can calculate get the right lift for
             any given index path, regardless whether the picker is showing or not and where it's located. However, for this situation, we know that the picker's index is not
             the same as the current table's index. So this means that the table index has to be below or above the picker's index. The helper method supports these two checks.
             If the table index is less than the picker's index, then we know that the index of the lift hasn't been displaced as the picker only displaces indexes larger than it.
             If the table index is greater the picker's index, then to determine the index of the lift, we just subtract the current index by 1 to get the correct lift to populate
             this cell.
             
             In both these cases, the first thing that happens is a cell with the textFieldCell prototype is created. Next, the proper lift to populate the cell with data is found.
             For the case when the picker isn't showing, the lift corresponding to the row of the table index is returned. When the picker is showing but the current table index is
             not the same as the index of the picker, we employ checks to determine if the current table index is above or below the picker index. This way, we can decide whether to
             use the lift corresponding to the current row of the table index or the lift corresponding to the row above the table index.
            */
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldCell
            
            let lift = calculateLiftForIndexPath(indexPath: indexPath)
            cell.configureWithField(mainLift: lift, editable: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Checks to see if the section of the indexPath corresponds with the picker section. If not, then the picker is dismissed.
        if !pickerShouldAppearAtRowForSelectionAtIndexPath(indexPath: indexPath) {
            dismissPickerRow()
            return
        }
        
        self.view.endEditing(true)
        
        //used for animating the deletion of rows inbetween
        tableView.beginUpdates()
        
        //We know that the selected row supports a picker and here we are checking if there is a current picker visible
        if pickerVisible {
            /*Since there is a picker show already, and a row was just selected, we want to delete the picker from the table. This is because
             there can only be two scenarios: one where the current picker is closed and no other picker is opened or one where the current picker is closed and
             another picker is opened. No matter the case, the current picker has to be deleted from the table. That's why following, we test to see if we should
             insert a new picker at a different row.
            */
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            let oldPickerIndexPath = pickerIndexPath!
            
            //Tests to see if this is the same row that opened the current picker in the first place. If yes, then the table needs not be changed anymore.
            if pickerIsRightBelowMe(indexPath: indexPath) {
                //close the picker
                pickerIndexPath = nil
            } else {
                /* If the index is greater than the old picker index, then the new insertion for the picker remains at the current index. This is because
                 every index that was greater than the old picker index is shifted down one in the new tableview, since the previous picker was deleted. Therefore,
                 it makes sense that inserting the row for the new picker should just stay at the current index.
                 
                 But what if the index is less than the old picker index? As mentioned earlier, only the indexes greater than the old picker index were shifted down
                 one; indexes less than the old picker index remain the same. Therefore, the row to add a new picker would be the row right below the current index.
                */
                let newRow = oldPickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                pickerIndexPath = IndexPath(row: newRow, section: indexPath.section)
                tableView.insertRows(at: [pickerIndexPath!], with: .fade)
            }
        } else {
            //Since no picker is visible, all we have to do is insert a picker under the current row.
            pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [pickerIndexPath!], with: .fade)
        }
        tableView.endUpdates()
    }
    
    //MARK: Helper methods
    func calculateLiftForIndexPath(indexPath: IndexPath) -> Lift {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if pickerIndexPath!.row == indexPath.row {
                //picker row matches current indexpath row, so return the lift above this cell
                return lifts[indexPath.row - 1]
            } else if pickerIndexPath!.row > indexPath.row {
                //current indexpath row is less than the picker so it's safe to just return the lift at the current cell
                return lifts[indexPath.row]
            } else {
                //current indexpath row is above the picker so return the lift above this row
                return lifts[indexPath.row - 1]
            }
        } else {
            //since the picker isn't showing, just return the current lift at cell
            return lifts[indexPath.row]
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
    func dayChangedForField(mainLift: Lift, toDay day: String) {
        print("Day changed for \(mainLift.name) to \(day)")
        let index = lifts.firstIndex(of: mainLift)
        mainLift.day = day
        lifts[index!] = mainLift
        tableView.reloadData()
    }
    
    func liftChangedForField(mainLift: Lift, toLift lift: String) {
        print("BBB lift changed for \(mainLift.name) to \(lift)")
        let index = lifts.firstIndex(of: mainLift)
        mainLift.bbbLift = lift
        lifts[index!] = mainLift
        tableView.reloadData()
    }
}
