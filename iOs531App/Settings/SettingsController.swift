//
//  SettingsController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

/*
 Will attempt to recover by breaking constraint
 <NSLayoutConstraint:0x600000a60410 'TB_Trailing_Trailing' H:[_UIModernBarButton:0x7fea28e2f450'Done']-(20)-|   (active, names: '|':_UIButtonBarButton:0x7fea28e2e240 )>
 */

extension SettingsController: TrainingMaxCellDelegate {
    func maxChangedForField(mainLift: Lift, max: Double) {
        let index = lifts.firstIndex(of: mainLift)
        let sectionIndex = headerTitles.firstIndex(of: "Training maxes")
        let cell = tableView.cellForRow(at: IndexPath(row: index!, section: sectionIndex!)) as! TrainingMaxCell
        let roundTo = roundValues[selectedRoundToIndex]
        let roundedNum = round(max/roundTo)*roundTo
        cell.liftMaxField.placeholder = "\(roundedNum) lb"
        cell.liftMaxField.text = ""
    }
}

extension SettingsController: ProgressionCellDelegate {
    func progressionChangedForField(mainLift: Lift, progression: Double) {
        let index = lifts.firstIndex(of: mainLift)
        let sectionIndex = headerTitles.firstIndex(of: "Weight Progression")
        let cell = tableView.cellForRow(at: IndexPath(row: index!, section: sectionIndex!)) as! ProgressionCell
        let roundTo = roundValues[selectedRoundToIndex]
        let roundedNum = round(progression/roundTo)*roundTo
        cell.progressionField.placeholder = "\(roundedNum) lb"
        cell.progressionField.text = ""
    }
}

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, DayAndLiftPickerCellDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Table Data Sources
    let roundValues : [Double] = [2.5, 5, 10]
    var selectedRoundToIndex: Int = 1
    var lifts : [Lift] = []
    
    let headerTitles = ["Program Template", "Assistance Work", "Round to smallest weight", "Training maxes", "Weight Progression", "Timers"]
    
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
        
        if let roundValue = defaults.value(forKey: "roundTo") as? Double {
            let index = roundValues.firstIndex(of: roundValue)
            selectedRoundToIndex = index!
        }
        
        for lift in lifts {
            print("\(lift.name) + \(lift.trainingMax) + \(lift.progression)")
        }
        print(roundValues[selectedRoundToIndex])

    }

    //MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        //if picker is visible, add one to the list of lifts for row count
        case 0:
            return pickerVisible ? lifts.count + 1 : lifts.count
        case 1:
            return 0
        case 2:
            return roundValues.count
        case 3:
            return lifts.count
        case 4:
            return lifts.count
        case 5:
            return 0
        default:
            ()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
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
        case 1:
            ()
        case 2:
            let cell: RoundToCell = tableView.dequeueReusableCell(withIdentifier: "roundToCell") as! RoundToCell
            cell.weightLabel?.text = "\(roundValues[indexPath.row]) lb"
            //Checks to see if the current row selected should be checked.
            if indexPath.row == selectedRoundToIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        case 3:
            let cell: TrainingMaxCell = tableView.dequeueReusableCell(withIdentifier: "trainingMaxCell") as! TrainingMaxCell
            let lift = lifts[indexPath.row]
            cell.liftLabel?.text = lift.name
            cell.liftMaxField?.placeholder = "\(lift.trainingMax) lb"
            cell.delegate = self
            cell.configureWithField(mainLift: lift)
            return cell
        case 4:
            let cell: ProgressionCell = tableView.dequeueReusableCell(withIdentifier: "progressionCell") as! ProgressionCell
            let lift = lifts[indexPath.row]
            cell.progressionLiftLabel?.text = lift.name
            cell.progressionField?.placeholder = "\(lift.progression) lb"
            cell.delegate = self
            cell.configureWithField(mainLift: lift)
            return cell
        case 5:
            ()
        default:
            ()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if section==0{
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
        } else if section==2 {
            //Deselecting the row removes the gray fill of the cell. Also makes clicking the cell look more animated
            tableView.deselectRow(at: indexPath, animated: true)
            
            //If the user clicks on the row that is currently checked, don't do anything.
            if indexPath.row == selectedRoundToIndex {
                return
            }
            
            /*Since we got past the check, we know that the user checked a different row. We take get the cell of the
             current row and set its accessory to checked. Then, we use the selectedRoundToIndex to make an indexpath
             to the old cell that is checked. Here, we just uncheck the old cell. Final step is to set the roundtoindex
             to the current indexpath's row.
             */
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
            
            let oldCell = tableView.cellForRow(at: IndexPath(row: selectedRoundToIndex, section: indexPath.section))
            oldCell?.accessoryType = .none
            
            selectedRoundToIndex = indexPath.row
        }
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
