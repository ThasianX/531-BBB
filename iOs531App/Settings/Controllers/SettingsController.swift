//
//  SettingsController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension SettingsController: AssistanceCatalogControllerDelegate {
    func assistanceSelectionComplete(index: Int) {
        let assistanceString = formatAssistanceExercisesForLift(id: Int64(index))
        let vm = viewModel.sectionVMs[1].rowVMs[index] as? AssistanceCellVM
        vm?.assistanceExercises = assistanceString
        delegate?.reloadAssistance(indexPath: IndexPath(row: index, section: 1))
    }
}

protocol SettingsControllerDelegate {
    func reloadAssistance(indexPath: IndexPath)
}

class SettingsController {
    
    //MARK: Data
    //Variables values that can only be set from viewmodel. Will be accessed by the view
    private (set) var roundValues: [Double]!
    private (set) var selectedRoundToIndex: Int!
    private (set) var headerTitles: [String]!
    private (set) var timerTitles: [String]!
    //Date picker related data
    private (set) var pickerIndexPath: IndexPath?
    var pickerVisible: Bool {
        return pickerIndexPath != nil
    }
    private (set) var lifts: [Lift]!
    private (set) var db: CycleDb!
    private (set) var selectedAssistanceIndex: Int?
    
    var delegate: SettingsControllerDelegate?
    let viewModel: SettingsVM
    
    init(viewModel: SettingsVM = SettingsVM()){
        log.verbose("SettingsVM is informed of the view did load call")
        self.viewModel = viewModel
        log.verbose("Grabbing database instance")
        db = CycleDb.instance
        
        log.verbose("Displaying current pr values:")
        for pr in db.getPrs() {
            log.verbose(pr)
        }
        
        log.verbose("Lifts are being loaded in from the database to populate the viewmodel")
        loadLifts()
        log.verbose("Configuring output properties that will be accessed by the view")
        configureOutput()
        
    }
    
    func populateViewModel(){
        var vm: RowViewModel?
        var sections = [SectionVM]()

        var rows = [RowViewModel]()
        log.info("Calling populateViewmodel")

        for section in 0..<headerTitles.count {
            switch section {
            case 0:
                for i in 0..<lifts.count {
                    let lift = lifts[i]
                    let bbbLift = db.getLift(cid: lift.bbbLiftId)
                    let schedulePickerVM: SchedulePickerVM = SchedulePickerVM(lift: lift, bbbLift: bbbLift!.name, indexPath: IndexPath(row: i, section: section))
                    log.debug("SchedulePickerVM created with: lift - \(schedulePickerVM.lift), bbbLift - \(schedulePickerVM.bbbLift)")
                    vm = schedulePickerVM
                    rows.append(vm!)
                }
            case 1:
                for i in 0..<lifts.count {
                    let lift = lifts[i]
                    
                    let assistanceString = formatAssistanceExercisesForLift(id: lift.id!)
                    
                    let assistanceVM: AssistanceCellVM = AssistanceCellVM(liftName: lift.name, assistanceExercises: assistanceString, index: i)
                    log.debug("AssistanceCellVM created with: liftName - \(assistanceVM.liftName), assistanceExercises - \(assistanceVM.assistanceExercises)")
                    vm = assistanceVM
                    rows.append(vm!)
                }
            case 2:
                for i in 0..<roundValues.count {
                    let roundToVM: RoundToCellVM = RoundToCellVM(weight: roundValues[i], isSelected: (selectedRoundToIndex==i))
                    log.debug("RoundToVM created with: weight - \(roundToVM.weight), isSelected - \(roundToVM.isSelected)")
                    vm = roundToVM
                    rows.append(vm!)
                }
            case 3:
                for i in 0..<lifts.count {
                    let editValueVM: EditValueVM = EditValueVM(liftName: lifts[i].name, fieldValue: lifts[i].trainingMax, index: i, section: section)
                    log.debug("EditValueVM created with: liftName - \(editValueVM.liftName), fieldValue - \(editValueVM.fieldValue), index - \(editValueVM.index), section - \(editValueVM.section)")
                    vm = editValueVM
                    rows.append(vm!)
                }
            case 4:
                for i in 0..<lifts.count {
                    let editValueVM: EditValueVM = EditValueVM(liftName: lifts[i].name, fieldValue: lifts[i].progression, index: i, section: section)
                    log.debug("EditValueVM created with: liftName - \(editValueVM.liftName), fieldValue - \(editValueVM.fieldValue), index - \(editValueVM.index), section - \(editValueVM.section)")
                    vm = editValueVM
                    rows.append(vm!)
                }
            case 5:
                for i in 0..<timerTitles.count {
                    let timerVM: TimerCellVM = TimerCellVM(timerLabel: timerTitles[i], isOn: UserDefaults.standard.value(forKey: SavedKeys.getTimerSwitchKeys(timer: i)) as! Bool)
                    log.debug("TimerVM created with: timerLabel - \(timerVM.timerLabel), isOn - \(timerVM.isOn)")
                    vm = timerVM
                    rows.append(vm!)
                }
            default:
                log.error("There should not be more than 6 sections")
                fatalError("There should not be more than 6 sections")
            }
            
            sections.append(SectionVM(rowVMs: rows, headerTitle: headerTitles[section]))
            log.debug("There are \(rows.count) rows in section \(section)")
            rows.removeAll()
        }

        self.viewModel.sectionVMs = sections
        log.debug("There are \(sections.count) sections")

    }
    
    //Loads the lifts required for populating the UI
    private func loadLifts() {
        lifts = db.getLifts()
        for lift in lifts {
            log.debug("Main lifts: Id - \(lift.id!) + Name - \(lift.name) + Training max - \(lift.trainingMax) + Progression - \(lift.progression) + BbbLiftId - \(lift.bbbLiftId)")
        }
    }
    
    //Configures the output properties that will be accessed by the view
    private func configureOutput(){
        let defaults = UserDefaults.standard
        roundValues = [2.5, 5, 10]
        selectedRoundToIndex = getRoundToIndex(value: defaults.value(forKey: SavedKeys.roundTo) as! Double)
        log.debug("Weights are currently being rounded to \(roundValues[selectedRoundToIndex]) lb")
        
        headerTitles = ["Program Template", "Assistance Work", "Round to smallest weight", "Training maxes", "Weight Progression", "Timer Cofiguration"]
        timerTitles = ["Show Warmup Timer", "Show 5/3/1 Timer", "Show BBB Timer", "Show Assistance Timer"]
    }
    
    //Determines whether to use the picker cell or the text field cell
    func shouldUsePicker(indexPath: IndexPath) -> Bool {
        return pickerVisible && pickerIndexPath! == indexPath
    }
    
    //Finds index of round to
    private func getRoundToIndex(value: Double) -> Int{
        return roundValues.firstIndex(of: value)!
    }
    
    //Updates roundToIndex
    func updateRoundToIndex(indexPath: IndexPath){
        log.debug("selectedRoundToIndex updated to \(indexPath.row)")
        
        let vm = viewModel.sectionVMs[indexPath.section].rowVMs[indexPath.row] as! RoundToCellVM
        vm.isSelected = true
        let oldVm = viewModel.sectionVMs[indexPath.section].rowVMs[selectedRoundToIndex] as! RoundToCellVM
        oldVm.isSelected = false
        
        selectedRoundToIndex = indexPath.row
        
        UserDefaults.standard.set(roundValues[selectedRoundToIndex], forKey: SavedKeys.roundTo)
    }
    
    //Returns roundTo value
    func getRoundTo() -> Double{
        log.debug("Returning roundTo value of \(roundValues[selectedRoundToIndex])")
        return roundValues[selectedRoundToIndex]
    }
    
    //Sets selected assistance index
    func updateSelectedAssistanceIndex(index: Int){
        log.debug("selectedAssistanceIndex updated to \(index)")
        selectedAssistanceIndex = index
    }
    
    //Rounds number based on input parameter
    private func calculateRoundedNum(num: Double) -> Double{
        let roundTo = roundValues[selectedRoundToIndex]
        return round(num/roundTo) * roundTo
    }
    
    //Sets pickerIndexPath
    func updatePickerIndexPath(index: IndexPath?) {
        pickerIndexPath = index
        if let index = pickerIndexPath {
            log.debug("PickerindexPath is now \(index)")
        } else {
            log.debug("PickerindexPath is now nil")
        }
        
    }
    
    func calculateIndexForIndexPath(indexPath: IndexPath) -> Int {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if pickerIndexPath!.row == indexPath.row {
                //picker row matches current indexpath row, so return the lift above this cell
                return indexPath.row - 1
            } else if pickerIndexPath!.row > indexPath.row {
                //current indexpath row is less than the picker so it's safe to just return the lift at the current cell
                return indexPath.row
            } else {
                //current indexpath row is above the picker so return the lift above this row
                return indexPath.row - 1
            }
        } else {
            //since the picker isn't showing, just return the current lift at cell
            return indexPath.row
        }
    }
    
    func pickerIsRightBelowMe(indexPath: IndexPath) -> Bool{
        if pickerVisible && pickerIndexPath!.section == indexPath.section{
            return indexPath.row == pickerIndexPath!.row - 1
        } else {
            return false
        }
    }
    
    //Returns the type of cell for tableview dequeue method
    func cellIdentifier(for viewModel: RowViewModel, indexPath: IndexPath) -> String{
        switch viewModel {
        case is SchedulePickerVM:
            log.debug("Determining whether to use the picker or text field")
            if shouldUsePicker(indexPath: indexPath) {
                log.debug("Cell identifier of dayAndLiftPickerCell")
                return "dayAndLiftPickerCell"
            } else {
                log.debug("Cell identifier of textFieldCell")
                return "textFieldCell"
            }
        case is AssistanceCellVM:
            log.debug("Cell identifier of assistanceCell")
            return "assistanceCell"
        case is RoundToCellVM:
            log.debug("Cell identifier of roundToCell")
            return "roundToCell"
        case is EditValueVM:
            log.debug("Cell identifier of editValueCell")
            return "editValueCell"
        case is TimerCellVM:
            log.debug("Cell identifier of timerCell")
            return "timerCell"
        default:
            log.error("Unexpected view model type: \(viewModel)")
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    //Updates training max
    func updateTrainingMax(index: Int, section: Int, max: Double) -> Double{
        let roundedNum = calculateRoundedNum(num: max)
        let lift = lifts[index]
        log.debug("Lift training max at index \(index) being updated from \(lift.trainingMax) lb to \(roundedNum) lb")
        lift.trainingMax = roundedNum
        
        if db.updateLift(cid: lift.id!, ctrainingMax: roundedNum) {
            log.info("Lift training max updated successfully in database")
        }
        
        let vm = viewModel.sectionVMs[section].rowVMs[index] as! EditValueVM
        vm.fieldValue = roundedNum
        
        return roundedNum
    }
    
    //Updates progression
    func updateProgression(index: Int, section: Int, progression: Double) -> Double{
        let roundedNum = calculateRoundedNum(num: progression)
        let lift = lifts[index]
        log.debug("Lift progression at index \(index) being updated from \(lift.progression) lb to \(roundedNum) lb")
        lift.progression = roundedNum
        
        if db.updateLift(cid: lift.id!, cprogression: roundedNum) {
            log.info("Lift progression updated successfully in database")
        }
        
        let vm = viewModel.sectionVMs[section].rowVMs[index] as! EditValueVM
        vm.fieldValue = roundedNum
        
        return roundedNum
    }
    
    //Updates progression
    func updateDay(indexPath: IndexPath, day: String){
        log.debug("updateDay being called with: indexPath - \(indexPath) + day - \(day)")
        
        lifts[indexPath.row].dayString = day
        let dayInt = convertDayToInt(dayString: day)
        lifts[indexPath.row].dayInt = dayInt
        
        if db.updateLift(cid: lifts[indexPath.row].id!, cdayString: day, cdayInt: dayInt) {
            log.info("Lift day updated successfully in database")
        }
        
        let vm = viewModel.sectionVMs[indexPath.section].rowVMs[indexPath.row] as! SchedulePickerVM
        vm.lift = lifts[indexPath.row]
        
    }
    
    //Updates BBB Lift
    func updateBbbLift(indexPath: IndexPath, bbbLift: String){
        log.debug("updateBBBLift being called with: indexPath - \(indexPath) + bbbLift - \(bbbLift)")
        
        let bbbLift = db.getLift(cname: bbbLift)
        lifts[indexPath.row].bbbLiftId = bbbLift!.id!
        
        if db.updateLift(cid: lifts[indexPath.row].id!, cbbbLiftId: bbbLift!.id!) {
            log.info("Lift bbbLiftId updated successfully in database")
        }
        
        let vm = viewModel.sectionVMs[indexPath.section].rowVMs[indexPath.row] as! SchedulePickerVM
        vm.bbbLift = bbbLift!.name
        
    }
    
    func formatAssistanceExercisesForLift(id: Int64) -> String{
        let assistanceExercises = db.getAssistanceExercisesForLift(cid: id)
        var assistanceString = ""
        for exercise in assistanceExercises {
            assistanceString.append("\u{2022}\(exercise.name) - \(exercise.sets)x\(exercise.reps)\n")
        }
        
        if assistanceString.count>0{
            assistanceString = String(assistanceString.prefix(assistanceString.count-1))
        }
        
        return assistanceString
    }
    
    func convertDayToInt(dayString: String) -> Int64 {
        switch dayString {
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        case "Sunday":
            return 7
        default:
            fatalError("String is not a day")
        }
    }
    
    //Updates timer state
    func updateTimerState(timerLabel: String, isOn: Bool){
        let rowIndex = timerTitles.firstIndex(of: timerLabel)
        let sectionIndex = headerTitles.firstIndex(of: "Timer Cofiguration")
        
        let vm = viewModel.sectionVMs[sectionIndex!].rowVMs[rowIndex!] as! TimerCellVM
        vm.isOn = isOn
        
        UserDefaults.standard.set(isOn, forKey: SavedKeys.getTimerSwitchKeys(timer: rowIndex!))
    }
    
    
    func prepareData(vc: AssistanceCatalogVC){
        vc.controller.lift = lifts[selectedAssistanceIndex!]
        vc.controller.index = selectedAssistanceIndex
        vc.controller.delegate = self
        log.debug("Passing to AssistanceCatalogVC: liftToPass - \(lifts[selectedAssistanceIndex!]) + indexToPass - \(selectedAssistanceIndex!)")
    }
    
}
