//
//  WeekController.swift
//  iOs531App
//
//  Created by Kevin Li on 10/11/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

protocol WeekControllerDelegate {
    func reloadPr(indexPath: IndexPath, timerOn: Bool)
}

protocol CheckBoxStatesDelegate {
    func setCheckBoxState(checkboxStates: [Bool])
}

class WeekController {
    private (set) var headerTitles: [String]!
    private (set) var currentSetDescription: String?
    private (set) var nextSetDescription: String?
    private (set) var roundTo: Double!
    private (set) var selectedDay: Int!
    private (set) var selectedTimer: Int?
    
    
    //Passed in values
    var lifts: [Lift]!
    var navTitle: String!
    var percentages: [Double]!
    var reps: [Int]!
    var checkBoxStates: [Bool]!
    var assistance: [[Assistance]]!
    
    private (set) var viewModel: WeekListVM
    private (set) var db: CycleDb
    
    var delegate: WeekControllerDelegate?
    var cbDelegate: CheckBoxStatesDelegate?
    
    init(viewModel: WeekListVM = WeekListVM()){
        log.info("WeekController aware of view did load call")
        self.viewModel = viewModel
        db = CycleDb.instance
        setupOutput()
    }
    
    func setupOutput(){
        headerTitles = ["Warmup Lifts", "5/3/1 Lifts", "BBB Lifts", "Assistance Lifts"]
        roundTo = UserDefaults.standard.value(forKey: SavedKeys.roundTo) as? Double
    }
    
    func initializeSelectedDay(){
        selectedDay = UserDefaults.standard.value(forKey: SavedKeys.getSelectedDay(week: navTitle)) as? Int
        log.info("Selected day is \(selectedDay!)")
    }
    
    func setupViewModel(){
        log.info("WeekController - setupViewModel called")
        viewModel.sectionVms.removeAll()
        var sectionVMs = [SectionSetVM]()
        var rowVMs = [SetViewModel]()
        var vm: SetViewModel?
        
        for (section, title) in headerTitles.enumerated() {
            let lift = lifts[selectedDay]
            switch section {
            case 0:
                for i in 0...2 {
                    let warmupSetVM = WarmupSetVM(lift: lift, roundTo: roundTo, isChecked: isChecked(row: i, section: section))
                    vm = warmupSetVM
                    rowVMs.append(vm!)
                }
                sectionVMs.append(SectionSetVM(rowVMs: rowVMs, headerTitle: "\(title) - \(lift.name)"))
            case 1:
                for i in 0...2 {
                    let mainSetVM = MainSetVM(lift: lift, roundTo: roundTo, reps: reps[i], percentage: percentages[i], isChecked: isChecked(row: i, section: section))
                    vm = mainSetVM
                    rowVMs.append(vm!)
                }
                sectionVMs.append(SectionSetVM(rowVMs: rowVMs, headerTitle: "\(title) - \(lift.name)"))
            case 2:
                let bbbLift = db.getCachedLift(cid: lift.bbbLiftId)
                for i in 0...4 {
                    let bbbSetVM = BbbSetVM(lift: bbbLift!, roundTo: roundTo, isChecked: isChecked(row: i, section: section))
                    vm = bbbSetVM
                    rowVMs.append(vm!)
                }
                sectionVMs.append(SectionSetVM(rowVMs: rowVMs, headerTitle: "\(title) - \(bbbLift!.name)"))
            case 3:
                let assistanceForDay = assistance[selectedDay]
                for i in 0..<assistanceForDay.count {
                    let assistanceSetVM = AssistanceSetVM(assistance: assistanceForDay[i], isChecked: isChecked(row: i, section: section))
                    vm = assistanceSetVM
                    rowVMs.append(vm!)
                }
                sectionVMs.append(SectionSetVM(rowVMs: rowVMs, headerTitle: "\(title)"))
            default:
                log.error("There is no such viewmodel")
            }
            
            log.info("There are \(rowVMs.count) rows in section \(section)")
            rowVMs.removeAll()
        }
        
        viewModel.sectionVms = sectionVMs
        log.info("There are \(sectionVMs.count) sections")
    }
    
    func cellIdentifier(vm: SetViewModel, indexPath: IndexPath) -> String{
        if (vm is MainSetVM) && indexPath.row == 2{
            return "prCell"
        }
        return "setCell"
    }
    
    private func isChecked(row: Int, section: Int) -> Bool{
        
        var pageIndex = 0
        for i in 0..<selectedDay {
            pageIndex += assistance[i].count + 11
        }
        
        let index = pageIndex+row
        
        switch section {
        case 0:
            return checkBoxStates[index]
        case 1:
            return checkBoxStates[index+3]
        case 2:
            return checkBoxStates[index+6]
        default:
            return checkBoxStates[index+11]
        }
    }
    
    func setChecked(indexPath: IndexPath, checked: Bool){
        let row = indexPath.row
        let section = indexPath.section
        
        var pageIndex = 0
        for i in 0..<selectedDay {
            pageIndex += assistance[i].count+11
        }
        
        let index = pageIndex+row
        
        switch section {
        case 0:
            checkBoxStates[index] = checked
        case 1:
            checkBoxStates[index+3] = checked
        case 2:
            checkBoxStates[index+6] = checked
        default:
            checkBoxStates[index+11] = checked
        }
        
        cbDelegate?.setCheckBoxState(checkboxStates: checkBoxStates)
        
        viewModel.sectionVms[section].rowVMs[row].setChecked(checked: checked)
    }
    
    func setupPrAlert(indexPath: IndexPath) -> UIAlertController{
        let lift = lifts[selectedDay]
        
        let alert = UIAlertController(title: "Personal Record", message: "Enter your new personal record for \(lift.name)", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter new PR"
            textField.keyboardType = .numberPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let newPrTextField = alert.textFields![0] as UITextField
            if let newPr = newPrTextField.text, let prVal = Int64(newPr){
                //First, add newPr to the prValues array
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let dateString = dateFormatter.string(from: date)
                
                self.db.addPr(cdate: dateString, cpr: prVal, cname: lift.name)
                
                let vm = self.viewModel.sectionVms[indexPath.section].rowVMs[indexPath.row] as? MainSetVM
                
                if prVal > lift.personalRecord {
                    lift.personalRecord = prVal
                    vm?.lift = lift
                    vm?.prLabel = "Achieved a new PR of \(lift.personalRecord) reps"
                } else {
                    vm?.prLabel = "Lower PR of \(prVal) reps this time. Beat \(lift.personalRecord) reps next time"
                }
            }
            self.setChecked(indexPath: indexPath, checked: true)
            var timerOn = false
            
            if self.timerEnabled(section: indexPath.section) {
                self.setupSetDescriptions(indexPath: indexPath)
                timerOn = true
            }
            self.delegate?.reloadPr(indexPath: indexPath, timerOn: timerOn)
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        return alert
    }
    
    func setSelectedDay(index: Int){
        selectedDay = index
        UserDefaults.standard.set(selectedDay, forKey: SavedKeys.getSelectedDay(week: navTitle))
        log.info("Selected day set to \(selectedDay!)")
    }
    
    func setupSetDescriptions(indexPath: IndexPath){
        currentSetDescription = "Completed:  \(viewModel.sectionVms[indexPath.section].headerTitle) |  \(viewModel.sectionVms[indexPath.section].rowVMs[indexPath.row].getLabel())"
        if let nextCellIndexPath = nextCellIndexPath(currentIndexPath: indexPath) {
            nextSetDescription = "Upcoming:  \(viewModel.sectionVms[indexPath.section].headerTitle) |  \(viewModel.sectionVms[nextCellIndexPath.section].rowVMs[nextCellIndexPath.row].getLabel())"
        } else {
            nextSetDescription = "This is your last set! Well done!"
        }
    }
    
    func timerEnabled(section: Int) -> Bool{
        let defaults = UserDefaults.standard
        
        let timer = SavedKeys.getTimerSwitchKeys(timer: section)
        
        if defaults.value(forKey: timer) as! Bool{
            selectedTimer = section
            return true
        }
        
        return false
    }
    
    func nextCellIndexPath(currentIndexPath: IndexPath) -> IndexPath? {
        let startRow = currentIndexPath.row
        let startSection = currentIndexPath.section
        
        var nextRow = startRow
        var nextSection = startSection
        
        if nextSection == 3 && nextRow == (viewModel.sectionVms[3].rowVMs.count-1){
            return nil
        } else if startRow == (viewModel.sectionVms[startSection].rowVMs.count-1) {
            if viewModel.sectionVms[3].rowVMs.count == 0 {
                return nil
            } else {
                nextSection+=1
                nextRow = 0
            }
        } else {
            nextRow+=1
        }
        
        return IndexPath(row: nextRow, section: nextSection)
    }
    
    func getLiftDays() -> [String]{
        var days = [String]()
        for lift in lifts {
            days.append(lift.dayString)
        }
        return days
    }
    
    func prepareData(vc: TimerVC) {
        let time = UserDefaults.standard.value(forKey: SavedKeys.getTimeLeftKeys(timer: selectedTimer!)) as! Int
        vc.timeLeft = time
        vc.finishedSet = currentSetDescription
        vc.nextSet = nextSetDescription
        vc.selectedTimer = selectedTimer
        log.info("Starting time for this set is \(time) seconds")
    }
}
