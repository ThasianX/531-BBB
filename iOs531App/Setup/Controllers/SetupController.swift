//
//  Lift.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SetupController{
    
    //MARK: Data
    //Variables values that can only be set from viewmodel. Will be accessed by the view
    private (set) var roundValues: [Double]!
    private (set) var selectedRoundToIndex: Int!
    private (set) var headerTitles: [String]!
    
    let viewModel: SetupListViewModel
    
    //Data model of the viewmodel
    var lifts : [Lift]!
    
    init(viewModel: SetupListViewModel = SetupListViewModel()){
        self.viewModel = viewModel
        
        log.info("SetupViewModel is informed of the view did load call")
        log.info("Data Model of view model is configured by passing lift data into configureLifts(lifts:)")
        configureLifts(lifts: liftData())
        log.info("Configuring output properties that will be accessed by the view")
        configureOutput()
    }
    
    func populateViewModel(){
        var vm: RowViewModel?
        var sections = [SectionVM]()
        
        var rows = [RowViewModel]()
        
        for section in 0..<headerTitles.count {
            if section == 0 {
                for i in 0..<roundValues.count {
                    let roundToVM: RoundToCellVM = RoundToCellVM(weight: roundValues[i], isSelected: (selectedRoundToIndex==i))
                    log.debug("RoundToVM created with: weight - \(roundToVM.weight), isSelected - \(roundToVM.isSelected)")
                    vm = roundToVM
                    rows.append(vm!)
                }
            } else if section == 1 {
                for i in 0..<lifts.count {
                    let editValueVM: EditValueVM = EditValueVM(liftName: lifts[i].name, fieldValue: lifts[i].trainingMax, index: i, section: section)
                    log.debug("EditValueVM created with: liftName - \(editValueVM.liftName), fieldValue - \(editValueVM.fieldValue), index - \(editValueVM.index), section - \(editValueVM.section)")
                    vm = editValueVM
                    rows.append(vm!)
                }
            } else if section == 2 {
                for i in 0..<lifts.count {
                    let editValueVM: EditValueVM = EditValueVM(liftName: lifts[i].name, fieldValue: lifts[i].progression, index: i, section: section)
                    log.debug("EditValueVM created with: liftName - \(editValueVM.liftName), fieldValue - \(editValueVM.fieldValue), index - \(editValueVM.index), section - \(editValueVM.section)")
                    vm = editValueVM
                    rows.append(vm!)
                }
            }
            sections.append(SectionVM(rowVMs: rows, headerTitle: headerTitles[section]))
            log.debug("There are \(rows.count) rows in section \(section)")
            rows.removeAll()
        }
        
        self.viewModel.sectionVMs = sections
        log.debug("There are \(sections.count) sections")
        
    }
    
    //Generates default lift data in response to a request
    private func liftData() -> [Lift]{
        return SetupData.generateLifts()
    }
    
    //Configures the lifts required for populating the UI
    private func configureLifts(lifts: [Lift]) {
        self.lifts = lifts
    }
    
    //Configures the output properties that will be accessed by the view
    private func configureOutput(){
        roundValues = [2.5, 5, 10]
        selectedRoundToIndex = 1
        headerTitles = ["Round to smallest weight", "Training maxes", "Weight progression"]
    }
    
    //Returns the type of cell for tableview dequeue method
    func cellIdentifier(for viewModel: RowViewModel) -> String{
        switch viewModel {
        case is RoundToCellVM:
            log.debug("Cell identifier of roundToCell")
            return "roundToCell"
        case is EditValueVM:
            log.debug("Cell identifier of editValueCell")
            return "editValueCell"
        default:
            log.error("Unexpected view model type: \(viewModel)")
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    //Updates roundToIndex
    func updateRoundToIndex(roundToIndex: Int){
        log.debug("selectedRoundToIndex updated to \(roundToIndex)")
        selectedRoundToIndex = roundToIndex
    }
    
    //Returns roundTo value
    func getRoundTo() -> Double{
        log.debug("Returning roundTo value of \(roundValues[selectedRoundToIndex])")
        return roundValues[selectedRoundToIndex]
    }
    
    //Rounds number based on input parameter
    private func calculateRoundedNum(num: Double) -> Double{
        let roundTo = roundValues[selectedRoundToIndex]
        return round(num/roundTo) * roundTo
    }
    
    //Updates training max
    func updateTrainingMax(index: Int, max: Double) -> Double{
        let roundedNum = calculateRoundedNum(num: max)
        log.debug("Lift training max at index \(index) being updated from \(lifts[index].trainingMax) lb to \(roundedNum) lb")
        lifts[index].trainingMax = roundedNum
        return roundedNum
    }
    
    //Updates progression
    func updateProgression(index: Int, progression: Double) -> Double{
        let roundedNum = calculateRoundedNum(num: progression)
        log.debug("Lift progression at index \(index) being updated from \(lifts[index].progression) lb to \(roundedNum) lb")
        lifts[index].progression = roundedNum
        return roundedNum
    }
    
    func savePreferences(){
        let defaults = UserDefaults.standard
        //Saving setup value so that setup doesn't get called again
        defaults.set(true, forKey: SavedKeys.finishedSetup)
        log.debug("Finished setup value saved: \(defaults.value(forKey: SavedKeys.finishedSetup) as! Bool)")

        //Saving roundTo value
        defaults.set(getRoundTo(), forKey: SavedKeys.roundTo)
        log.debug("RoundTo value saved: \(defaults.value(forKey: SavedKeys.roundTo) as! Double) lb")

        //Setting timer defaults to true
        defaults.set(true, forKey: SavedKeys.getTimerSwitchKeys(timer: 0))
        defaults.set(true, forKey: SavedKeys.getTimerSwitchKeys(timer: 1))
        defaults.set(true, forKey: SavedKeys.getTimerSwitchKeys(timer: 2))
        log.debug("531 Timer value(on/off) saved: \(defaults.value(forKey: SavedKeys.getTimerSwitchKeys(timer: 0)) as! Bool)")
        log.debug("BBB Timer value(on/off) saved: \(defaults.value(forKey: SavedKeys.getTimerSwitchKeys(timer: 1)) as! Bool)")
        log.debug("Ass Timer value(on/off) saved: \(defaults.value(forKey: SavedKeys.getTimerSwitchKeys(timer: 2)) as! Bool)")


        //One time initialization for checkbox state arrays
        var checkboxStateArray: [[Bool]] = [[], [], [], []]
        for i in 0...3 {
            for _ in 0...43 {
                checkboxStateArray[i].append(false)
            }
        }
        defaults.set(checkboxStateArray, forKey: SavedKeys.checkboxStates)
        log.debug("Checkbox state array saved: \(defaults.value(forKey: SavedKeys.checkboxStates) as! [[Bool]])")

        //Setting initial values for each timer
        defaults.set(90, forKey: SavedKeys.getTimeLeftKeys(timer: 0))
        defaults.set(90, forKey: SavedKeys.getTimeLeftKeys(timer: 1))
        defaults.set(90, forKey: SavedKeys.getTimeLeftKeys(timer: 2))
        log.debug("531 time saved: \(defaults.value(forKey: SavedKeys.getTimeLeftKeys(timer: 0)) as! Int)")
        log.debug("BBB time saved: \(defaults.value(forKey: SavedKeys.getTimeLeftKeys(timer: 1)) as! Int)")
        log.debug("Ass time saved: \(defaults.value(forKey: SavedKeys.getTimeLeftKeys(timer: 2)) as! Int)")
    }
    
    func setupDatabase(){
        let db = CycleDb.instance

        for lift in lifts {
            db.addLift(lift: lift)
        }

        let mainLifts = db.getLifts()
        log.debug("There should be 4 lifts: \(mainLifts.count)")

        for lift in mainLifts {
            log.debug("Name: \(lift.name), Max: \(lift.trainingMax), Progression: \(lift.progression)")
        }
    }
    
}
