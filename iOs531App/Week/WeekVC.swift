//
//  WeekVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol WeekVCDelegate: class {
    func setCheckedState(section: Int, index: Int, checked: Bool)
    func workoutComplete()
}

extension WeekVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section called")
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 5
        default:
            return assistanceForEachDay[daysSegControl.selectedSegmentIndex]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Making cells")
        let index = daysSegControl.selectedSegmentIndex
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
            let weight = round((0.4 * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
            cell.setLabel.text = "5 reps at \(weight) lbs"
            cell.setDescription.text = "40% of your training max"
            if isChecked(indexPath: indexPath){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        case 1:
            print(tableView.numberOfRows(inSection: indexPath.section))
            if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "prCell") as! PrCell
                //Index is wrong
                let weight = round((percentagesToPass[2] * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
                cell.setLabel.text = "\(repsToPass[2]) reps at \(weight) lbs"
                cell.setDescription.text = "\(Int(percentagesToPass[2]*100.0))% of your training max"
                //Index is wrong.
                cell.prLabel.text = "Beat your previous PR of \(liftsToPass[index].personalRecord)"
                if isChecked(indexPath: indexPath){
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
                print(indexPath.row)
                print(index)
                let weight = round((percentagesToPass[indexPath.row] * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
                cell.setLabel.text = "\(repsToPass[indexPath.row]) reps at \(weight) lbs"
                cell.setDescription.text = "\(Int(percentagesToPass[indexPath.row]*100.0))% of your training max"
                if isChecked(indexPath: indexPath){
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
            //Index is wrong
            let weight = round((0.6 * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
            cell.setLabel.text = "10 reps at \(weight) lbs"
            cell.setDescription.text = "60% of your training max"
            if isChecked(indexPath: indexPath){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
            //Need index to find out the assistance lifts
            let index = assistanceForEachDay[daysSegControl.selectedSegmentIndex]-assistanceForEachDay[0]+indexPath.row
            
            cell.setLabel.text = "\(assistanceChunks[index].liftName) for \(assistanceChunks[index].reps) reps"
            cell.setDescription.text = "Keep that grind going"
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < 3 {
            return "\(headerTitles[section]) - \(liftsToPass[daysSegControl.selectedSegmentIndex].name)"
        } else {
            return headerTitles[section]
        }
    }
    
}

extension WeekVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let cell = self.tableView.cellForRow(at: indexPath) as! SetCell
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                setChecked(indexPath: indexPath, checked: false)
            } else {
                cell.accessoryType = .checkmark
                setChecked(indexPath: indexPath, checked: true)
            }
            return
        }
        
        var setDescription: String?
        var nextSetDescription: String?
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = self.tableView.cellForRow(at: indexPath) as! SetCell
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    setChecked(indexPath: indexPath, checked: false)
                    return
                } else {
                    cell.accessoryType = .checkmark
                    let nextIndex = IndexPath(row: 1, section: 1)
                    let nextCell = self.tableView.cellForRow(at: nextIndex) as! SetCell
                    setDescription = "Completed: \(cell.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].name)"
                    nextSetDescription = "Upcoming: \(nextCell.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].name)"
                    setChecked(indexPath: indexPath, checked: true)
                }
                
            } else if indexPath.row == 1 {
                
                let cell = self.tableView.cellForRow(at: indexPath) as! SetCell
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    setChecked(indexPath: indexPath, checked: false)
                    return
                } else {
                    cell.accessoryType = .checkmark
                    let nextIndex = IndexPath(row: 2, section: 1)
                    let nextCell = self.tableView.cellForRow(at: nextIndex) as! PrCell
                    setDescription = "Completed: \(cell.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].name)"
                    nextSetDescription = "Upcoming: \(nextCell.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].name)"
                    setChecked(indexPath: indexPath, checked: true)
                }
                
            } else {
                
                let cell = self.tableView.cellForRow(at: indexPath) as! PrCell
                
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    setChecked(indexPath: indexPath, checked: false)
                    return
                } else {
                    let lift = liftsToPass[daysSegControl.selectedSegmentIndex]
                    //Ask to input new PR first if not checked
                    let alert = UIAlertController(title: "Personal Record", message: "Enter your new personal record for \(lift.name)", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "Enter new PR"
                        textField.keyboardType = .numberPad
                    })
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        let newPrTextField = alert.textFields![0] as UITextField
                        if let newPr = newPrTextField.text, let prVal = Int(newPr){
                            //First, add newPr to the prValues array
                            self.addNewPr(newPr:prVal)
                            if prVal > lift.personalRecord {
                                cell.prLabel.text = "Achieved a new PR of \(prVal)"
                                self.updatePr(newPr: prVal)
                            } else {
                                cell.prLabel.text = "Not quite this time. Beat \(lift.personalRecord) reps next time"
                            }
                        }
                        cell.accessoryType = .checkmark
                    } ))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
                    
                    self.present(alert, animated: true, completion: nil)
                    //start timer
                    let nextIndex = IndexPath(row: 0, section: 2)
                    let nextCell = self.tableView.cellForRow(at: nextIndex) as! SetCell
                    setDescription = "Completed: \(cell.setLabel.text!) of \(lift.name)"
                    nextSetDescription = "Upcoming: \(nextCell.setLabel.text!) of \(lift.bbbLift)"
                    setChecked(indexPath: indexPath, checked: true)
                }
            }
            
        } else if indexPath.section == 2 {
            let cell = self.tableView.cellForRow(at: indexPath) as! SetCell
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                setChecked(indexPath: indexPath, checked: false)
                return
            } else {
                cell.accessoryType = .checkmark
                setChecked(indexPath: indexPath, checked: true)
                
                setDescription = "Completed: \(cell.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].bbbLift)"
                
                if let nextCellIndexPath = nextCellIndexPath(currentIndexPath: indexPath) {
                    let nextCell = self.tableView.cellForRow(at: nextCellIndexPath) as? SetCell
                    
                    nextSetDescription = "Upcoming: \(nextCell!.setLabel.text!) of \(liftsToPass[daysSegControl.selectedSegmentIndex].bbbLift)"
                } else {
                    nextSetDescription = "This is your last set! Well done!"
                }
            }
        } else {
            //Do assistance cell stuff here
        }
        
        timerEnabled(section: indexPath.section, setDescription: setDescription!, nextSetDescription: nextSetDescription!)
    }
    
}

class WeekVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var daysSegControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: WeekVCDelegate?
    
    //MARK: Data
    let headerTitles = ["Warmup Lifts", "5/3/1 Lifts", "BBB Lifts", "Assistance Lifts"]
    var liftsToPass: [Lift]!
    var percentagesToPass: [Double]!
    var repsToPass: [Int]!
    var roundTo: Double!
    var selectedTimer: Int?
    var currentSetDescription: String?
    var nextSetDescription: String?
    var checkboxStates: [Bool]!
    var assistanceForEachDay: [Int]!
    var assistanceChunks: [AssistanceChunk]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameSegmentedControls()
        //Use segmented control to select the index of where the user last left off
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.workoutComplete()
    }
    
    //MARK: Segmented Control Action
    @IBAction func showDay(_ sender: UISegmentedControl) {
        switch daysSegControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
        case 1:
            tableView.reloadData()
        case 2:
            tableView.reloadData()
        default:
            tableView.reloadData()
        }
    }
    
    //MARK: Helper methods
    
    func updatePr(newPr: Int){
        liftsToPass[daysSegControl.selectedSegmentIndex].personalRecord = newPr
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: liftsToPass!, requiringSecureCoding: false){
            UserDefaults.standard.set(savedData, forKey: "cachedLifts")
        }
    }
    
    func addNewPr(newPr: Int){
        var prValues = UserDefaults.standard.value(forKey: "prValues") as! [[Int]]
        prValues[daysSegControl.selectedSegmentIndex].append(newPr)
        UserDefaults.standard.set(prValues, forKey: "prValues")
    }
    
    func countSetsOfAssistance(assistance: [String]) -> Int {
        var sets = 0
        for exercise in assistance{
            let setIndex = exercise.index(exercise.startIndex, offsetBy: exercise.count-2)
            sets += Int(String(exercise[setIndex]))!
        }
        return sets
    }
    
    func nameSegmentedControls(){
        for i in 0..<liftsToPass.count {
            daysSegControl.setTitle(liftsToPass[i].day, forSegmentAt: i)
        }
    }
    
    func timerEnabled(section: Int, setDescription: String, nextSetDescription: String){
        let defaults = UserDefaults.standard
        
        currentSetDescription = setDescription
        self.nextSetDescription = nextSetDescription
        
        switch section {
        case 1:
            let timer = defaults.value(forKey: "531") as! Bool
            if timer {
                selectedTimer = 0
                performSegue(withIdentifier: "showTimer", sender: self)
            }
        case 2:
            let timer = defaults.value(forKey: "BBB") as! Bool
            if timer {
                selectedTimer = 1
                performSegue(withIdentifier: "showTimer", sender: self)
            }
        case 3:
            let timer = defaults.value(forKey: "Ass") as! Bool
            if timer {
                selectedTimer = 2
                performSegue(withIdentifier: "showTimer", sender: self)
            }
        default:
            ()
        }
    }
    
    func nextCellIndexPath(currentIndexPath: IndexPath) -> IndexPath? {
        let startRow = currentIndexPath.row
        let startSection = currentIndexPath.section
        
        var nextRow = startRow
        var nextSection = startSection
        
        if nextSection == 3 && nextRow == (tableView.numberOfRows(inSection: 3)-1){
            return nil
        } else if startRow == (tableView.numberOfRows(inSection: startSection)-1) {
            if tableView.numberOfRows(inSection: 3) == 0 {
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
    
    private func isChecked(indexPath: IndexPath) -> Bool{
        let row = indexPath.row
        let section = indexPath.section
        
        var pageIndex = 0
        for i in 0..<daysSegControl.selectedSegmentIndex {
            pageIndex += assistanceForEachDay[i]+11 
        }
        
        switch section {
        case 0:
            return checkboxStates[pageIndex+row]
        case 1:
            return checkboxStates[pageIndex+row+3]
        case 2:
            return checkboxStates[pageIndex+row+6]
        default:
            return checkboxStates[pageIndex+row+11]
        }
    }
    
    private func setChecked(indexPath: IndexPath, checked: Bool){
        let row = indexPath.row
        let section = indexPath.section
        
        var pageIndex = 0
        for i in 0..<daysSegControl.selectedSegmentIndex {
            pageIndex += assistanceForEachDay[i]+11
        }
        
        let index = pageIndex+row
        
        switch section {
        case 0:
            checkboxStates[index] = checked
        case 1:
            checkboxStates[index+3] = checked
        case 2:
            checkboxStates[index+6] = checked
        default:
            checkboxStates[index+11] = checked
        }
        
        delegate?.setCheckedState(section: section, index: index, checked: checked)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimer" {
            let vc = segue.destination as! TimerVC
            if let timerIndex = selectedTimer {
                let time = UserDefaults.standard.value(forKey: "timer\(timerIndex)") as! Double
                vc.timeLeft = time
                vc.finishedSet = currentSetDescription
                vc.nextSet = nextSetDescription
                print("Starting time is \(time) seconds")
                print("\(currentSetDescription!)")
                print("\(nextSetDescription!)")
            }
        }
    }
}
