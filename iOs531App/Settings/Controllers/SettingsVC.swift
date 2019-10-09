//
//  SettingsVC.swift
//  iOs531App
//
//  Created by Kevin Li on 10/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension SettingsVC: EditValueCellDelegate {
    func valueChangedForField(index: Int, section: Int, value: Double) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: section)) as! EditValueCell
        
        let roundedValue = (section==3) ? controller.updateTrainingMax(index: index, section: section, max: value) : controller.updateProgression(index: index, section: section, progression: value)
        
        cell.updateField(num: roundedValue)
        
    }
    
}

extension SettingsVC: TimerCellDelegate {
    func stateChanged(timerLabel: String, isOn: Bool) {
        controller.updateTimerState(timerLabel: timerLabel, isOn: isOn)
    }
}

extension SettingsVC: AssistanceCatalogVCDelegate {
    func assistanceSelectionComplete(index: Int) {
        print("Assistance selection complete. Reloading row at \(index)")
        tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
    }

    func assistanceExerciseSelected(lift: Lift, index: Int) {
//        print("Assistance exercise selected for \(lift.name).")
//        lifts[index].assistanceLifts = lift.assistanceLifts
//
//        saveLifts()
    }
}

extension SettingsVC: DayAndLiftPickerCellDelegate {
    func dayChangedForField(indexPath: IndexPath, to day: String) {
        
        controller.updateDay(indexPath: indexPath, day: day)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func bbbLiftChangedForField(indexPath: IndexPath, to bbbLift: String) {
        controller.updateBbbLift(indexPath: indexPath, bbbLift: bbbLift)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Table Data Sources
    //MARK: ViewModel
    var viewModel: SettingsVM {
        return controller.viewModel
    }
    
    lazy var controller: SettingsController = {
        return SettingsController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("SettingsVC view did load called.")
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        log.info("ViewModel being populated")
        controller.populateViewModel()
    }
    
    //MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionVMs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionVMs[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section==0 && controller.pickerVisible) ? viewModel.sectionVMs[section].rowVMs.count+1 :  viewModel.sectionVMs[section].rowVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        log.info("Cell for row at being called for tableview")
        let sectionVM = viewModel.sectionVMs[indexPath.section]
        var rowVM: RowViewModel
        
        /*We are setting up the appearance of cells in the table now. If there is a picker visible, which means a row that supports a picker must've been selected
        before remaking specific rows of the table, and the current index of that picker is the same as the current index of the table, then a new cell is created
        with the dayAndLiftPickerCell prototype. The cell is populated using data obtained from the parent cell, or the cell above, that opened it.
        */
        if indexPath.section==0{
            if controller.shouldUsePicker(indexPath: indexPath){
                rowVM = sectionVM.rowVMs[indexPath.row-1]
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
                let index = controller.calculateIndexForIndexPath(indexPath: indexPath)
                rowVM = sectionVM.rowVMs[index]
            }
        } else {
            rowVM = sectionVM.rowVMs[indexPath.row]
        }
        
        let identifier = controller.cellIdentifier(for: rowVM, indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowVM)
        }
        
        switch identifier {
        case "dayAndLiftPickerCell":
            let cell = cell as? DayAndLiftPickerCell
            cell?.delegate = self
        case "editValueCell":
            let cell = cell as? EditValueCell
            cell?.delegate = self
        case "timerCell":
            let cell = cell as? TimerCell
            cell?.delegate = self
        default:
            ()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (indexPath.section == 1) { controller.updateSelectedAssistanceIndex(index: indexPath.row)
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = viewModel.sectionVMs[indexPath.section]
        
        //Deselecting the row removes the gray fill of the cell. Also makes clicking the cell look more animated
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Checks to see if the section of the indexPath corresponds with the picker section. If not, then the picker is dismissed.
        if !pickerShouldAppearAtRowForSelectionAtIndexPath(indexPath: indexPath) {
            dismissPickerRow()
        }
        
        if indexPath.section == 0 {
            //used for animating the deletion of rows inbetween
            tableView.beginUpdates()
            
            //We know that the selected row supports a picker and here we are checking if there is a current picker visible
            if controller.pickerVisible {
                /*Since there is a picker show already, and a row was just selected, we want to delete the picker from the table. This is because
                 there can only be two scenarios: one where the current picker is closed and no other picker is opened or one where the current picker is closed and
                 another picker is opened. No matter the case, the current picker has to be deleted from the table. That's why following, we test to see if we should
                 insert a new picker at a different row.
                 */
                log.debug("Tableview deleting rows at \(controller.pickerIndexPath!)")
                
                tableView.deleteRows(at: [controller.pickerIndexPath!], with: .fade)
                let oldPickerIndexPath = controller.pickerIndexPath!
                
                //Tests to see if this is the same row that opened the current picker in the first place. If yes, then the table needs not be changed anymore.
                if controller.pickerIsRightBelowMe(indexPath: indexPath) {
                    //close the picker
                    controller.updatePickerIndexPath(index: nil)
                } else {
                    /* If the index is greater than the old picker index, then the new insertion for the picker remains at the current index. This is because
                     every index that was greater than the old picker index is shifted down one in the new tableview, since the previous picker was deleted. Therefore,
                     it makes sense that inserting the row for the new picker should just stay at the current index.
                     
                     But what if the index is less than the old picker index? As mentioned earlier, only the indexes greater than the old picker index were shifted down
                     one; indexes less than the old picker index remain the same. Therefore, the row to add a new picker would be the row right below the current index.
                     */
                    let newRow = oldPickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                    controller.updatePickerIndexPath(index: IndexPath(row: newRow, section: indexPath.section))
                    tableView.insertRows(at: [controller.pickerIndexPath!], with: .fade)
                }
            } else {
                //Since no picker is visible, all we have to do is insert a picker under the current row.
                controller.updatePickerIndexPath(index: IndexPath(row: indexPath.row + 1, section: indexPath.section))
                tableView.insertRows(at: [controller.pickerIndexPath!], with: .fade)
            }
            tableView.endUpdates()
        } else if sectionVM.rowVMs[indexPath.row] is ViewModelPressible {
            //If the user clicks on the row that is currently checked, don't do anything.
            if indexPath.row == controller.selectedRoundToIndex {
                return
            }
            
            /*Since we got past the check, we know that the user checked a different row. We take get the cell of the
             current row and set its accessory to checked. Then, we use the selectedRoundToIndex to make an indexpath
             to the old cell that is checked. Here, we just uncheck the old cell. Final step is to set the roundtoindex
             to the current indexpath's row.
             */
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
            
            let oldCell = tableView.cellForRow(at: IndexPath(row: controller.selectedRoundToIndex!, section: indexPath.section))
            oldCell?.accessoryType = .none
            
            controller.updateRoundToIndex(indexPath: indexPath)
        }
    }
    
    //MARK: Helper methods
    
    func pickerShouldAppearAtRowForSelectionAtIndexPath(indexPath : IndexPath) -> Bool{
        return indexPath.section == 0
    }
    
    func dismissPickerRow() {
        if !controller.pickerVisible {
            return
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [controller.pickerIndexPath!], with: .fade)
        controller.updatePickerIndexPath(index: nil)
        tableView.endUpdates()
        self.view.endEditing(true)
    }
    
    //MARK: Segue overriden methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAssistance" {
            let vc = segue.destination as! AssistanceCatalogVC
            controller.prepareData(vc: vc)
            vc.delegate = self
        }
    }
}
