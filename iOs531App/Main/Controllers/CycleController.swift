//
//  CycleController.swift
//  iOs531App
//
//  Created by Kevin Li on 10/10/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension CycleController: CheckBoxStatesDelegate {
    func setCheckBoxState(checkboxStates: [Bool]) {
        self.checkboxStates[selectedIndex!] = checkboxStates
        UserDefaults.standard.set(self.checkboxStates, forKey: SavedKeys.checkboxStates)
    }
}

class CycleController {
    
    //MARK: Data
    private (set) var weekTitles: [String]!
    private (set) var weekDescriptions: [String]!
    private (set) var weekReps: [[Int]]!
    private (set) var checkboxStates : [[Bool]]!
    private (set) var sortedLifts: [Lift]!
    private (set) var weekPercentages: [[Double]]!
    private (set) var selectedIndex: Int?
    private (set) var assistance = [[Assistance]]()
    
    private (set) var viewModel: CycleVM
    private (set) var db: CycleDb
    
    init(viewModel: CycleVM = CycleVM()){
        log.info("CycleController aware of viewdidload call")
        self.viewModel = viewModel
        db = CycleDb.instance
        setupOutput()
    }
    
    private func setupOutput(){
        weekTitles = ["Week 1", "Week 2", "Week 3", "Week 4"]
        weekReps = [[5,5,5],[3,3,3], [5,3,1],[5,5,5]]
        refreshCheckBoxState()
        executeDbTasks()
    }

    func refreshCheckBoxState(){
        checkboxStates = UserDefaults.standard.value(forKey: SavedKeys.checkboxStates) as? [[Bool]]
    }

    private func executeDbTasks() {
        let percentages = db.getPercentagesForProgram(name: SavedKeys.programName)

        weekPercentages = [[percentages.w1d1, percentages.w1d2, percentages.w1d3], [percentages.w2d1, percentages.w2d2, percentages.w2d3], [percentages.w3d1, percentages.w3d2, percentages.w3d3], [percentages.w4d1, percentages.w4d2, percentages.w4d3]]

        weekDescriptions = [
            "5/3/1 - \(weekPercentages[0][0]*100)% | \(weekPercentages[0][1]*100)% | \(weekPercentages[0][2]*100)%", "5/3/1 - \(weekPercentages[1][0]*100)% | \(weekPercentages[1][1]*100)% | \(weekPercentages[1][2]*100)%", "5/3/1 - \(weekPercentages[2][0]*100)% | \(weekPercentages[2][1]*100)% | \(weekPercentages[2][2]*100)%", "Deload - \(weekPercentages[3][0]*100)% | \(weekPercentages[3][1]*100)% | \(weekPercentages[3][2]*100)%"
        ]

        sortedLifts = db.getOrderedCachedLifts()
        setupAssistance()
    }

    func setupAssistance(){

        for (i, lift) in sortedLifts.enumerated() {

            let assistanceExercises = db.getCachedAssistanceExercisesForLift(cid: lift.id!)

            assistance.append([Assistance]())

            for exercise in assistanceExercises {
                for _ in 0..<exercise.sets {
                    assistance[i].append(exercise)
                }
            }
        }
        log.info("Cached assistance array values: \(assistance)")

    }

    func populateViewModel(){
        log.info("CycleController populateViewModel called")
        var vm: RowViewModel?
        var rowVMs = [RowViewModel]()
        
        for (i,week) in weekTitles.enumerated() {
            let weekDisplayVM = WeekDisplayVM(week: week, percentages: weekDescriptions[i], progress: calculateProgress(index: i))
            log.debug("WeekDisplayVM created with: week - \(weekDisplayVM.week) + percentages - \(weekDisplayVM.percentages) + progress - \(Int(weekDisplayVM.progress*100))")
            vm = weekDisplayVM
            rowVMs.append(vm!)
        }
        self.viewModel.rowVms = rowVMs
    }

    private func calculateProgress(index: Int)-> Float{
        let numberOfTrue = checkboxStates[index].filter{$0}.count
        log.debug("There are \(numberOfTrue) trues in the array of  \(checkboxStates[index].count) booleans")
        let progress = Float(Double(numberOfTrue) / Double(checkboxStates[index].count))
        return progress
    }
    
    func refreshSelectedRow(){
        let index = selectedIndex!
        
        let weekDisplayVM = WeekDisplayVM(week: weekTitles[index], percentages: weekDescriptions[index], progress: calculateProgress(index: index))
        log.debug("WeekDisplayVM created with: week - \(weekDisplayVM.week) + percentages - \(weekDisplayVM.percentages) + progress - \(weekDisplayVM.progress)")
        let vm: RowViewModel = weekDisplayVM
        self.viewModel.rowVms[index] = vm
    }
    
    func refreshCycleData(){
        log.info("Refreshing cycle data")
        sortedLifts = db.getOrderedCachedLifts()
    }
    
    func cellIdentifier(rowVM: RowViewModel) -> String {
        return "weekDisplayCell"
    }
    
    func setSelectedWeek(week: Int) -> Bool{
        selectedIndex = week
        return true
    }
    
    func resetCycle(){
        log.info("Cycle is being reset")
        
        let defaults = UserDefaults.standard
        
        //Resets checkbox states
        for i in 0...3 {
            //Have to remove all since number of assistance can be different for a new cycle
            checkboxStates[i].removeAll()
            for _ in 0..<44 {
                checkboxStates[i].append(false)
            }
        }
        
        //Get the new sorted lifts
        db.cacheLifts()
        sortedLifts = db.getOrderedCachedLifts()
        
        //Appends the correct number of falses and exercises to checkboxes and assistance array, respectively
        resetAssistanceAndCheckboxes()
        
        defaults.set(checkboxStates, forKey: SavedKeys.checkboxStates)
        
        //Resets where user last left off
        resetSelectedDays()
        
        //Resets pr labels
        db.resetCyclePrLabels()
        
        populateViewModel()
    }
    
    func resetAssistanceAndCheckboxes(){
        
        db.cacheAssistanceExercises()
        
        var exerciseCounter = 0
        
        for (i, lift) in sortedLifts.enumerated() {
            let assistanceExercises = db.getAssistanceExercisesForLift(cid: lift.id!)
            assistance[i].removeAll()
            
            log.debug("Assistance exercises: \(assistanceExercises)")
            
            for exercise in assistanceExercises {
                for _ in 0..<exercise.sets {
                    exerciseCounter += 1
                    assistance[i].append(exercise)
                    log.info("Assistance array in this iteration: \(assistance)")
                }
            }
        }
        
        for i in 0...3 {
            checkboxStates[i].removeAll()
            
            for _ in 0..<(44+exerciseCounter) {
                checkboxStates[i].append(false)
            }
        }
        
        log.info("Checkbox array values: \(checkboxStates!)")
        log.info("Assistance array values: \(assistance)")
    }
    
    func resetSelectedDays(){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: SavedKeys.getSelectedDay(week: "Week 1"))
        log.debug("Selected day saved: \(defaults.value(forKey: SavedKeys.getSelectedDay(week: "Week 1")) as! Int)")
        defaults.set(0, forKey: SavedKeys.getSelectedDay(week: "Week 2"))
        log.debug("Selected day saved: \(defaults.value(forKey: SavedKeys.getSelectedDay(week: "Week 2")) as! Int)")
        defaults.set(0, forKey: SavedKeys.getSelectedDay(week: "Week 3"))
        log.debug("Selected day saved: \(defaults.value(forKey: SavedKeys.getSelectedDay(week: "Week 3")) as! Int)")
        defaults.set(0, forKey: SavedKeys.getSelectedDay(week: "Week 4"))
        log.debug("Selected day saved: \(defaults.value(forKey: SavedKeys.getSelectedDay(week: "Week 4")) as! Int)")
    }
    
    func completeCycle(){
        log.info("Cycle completed.")
        
        log.info("Lifts being incremented")
        db.incrementLifts()
        
        //Get the new sorted lifts
        db.cacheLifts()
        sortedLifts = db.getOrderedCachedLifts()
        
        //Appends the correct number of falses and exercises to checkboxes and assistance array, respectively
        resetAssistanceAndCheckboxes()
        
        UserDefaults.standard.set(checkboxStates, forKey: SavedKeys.checkboxStates)
        
        //Resets where user last left off
        resetSelectedDays()
        
        //Resets pr labels
        db.resetCyclePrLabels()
        
        populateViewModel()
    }
    
    func prepareData(vc: WeekVC){
        print(sortedLifts)
        vc.controller.lifts = sortedLifts
        vc.controller.percentages = weekPercentages[selectedIndex!]
        vc.controller.navTitle = weekTitles[selectedIndex!]
        vc.controller.reps = weekReps[selectedIndex!]
        vc.controller.checkBoxStates = checkboxStates[selectedIndex!]
        vc.controller.assistance = assistance
        vc.controller.cbDelegate = self
    }
}

