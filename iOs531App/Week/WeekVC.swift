//
//  WeekVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol WeekVCDelegate: class {
    func setClicked(index: Int)
}

extension WeekVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section called")
        switch daysSegControl.selectedSegmentIndex {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 5
        default:
            return countSetsOfAssistance(assistance: liftsToPass[daysSegControl.selectedSegmentIndex].assistanceLifts)
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
            return cell
        case 1:
            if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "prCell") as! PrCell
                //Index is wrong
                let weight = round((percentagesToPass[2] * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
                cell.setLabel.text = "\(repsToPass[2]) reps at \(weight) lbs"
                cell.setDescription.text = "\(Int(percentagesToPass[2]*100.0))% of your training max"
                //Index is wrong.
                cell.prLabel.text = "Beat your previous PR of \(liftsToPass[index].personalRecord)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
                let weight = round((percentagesToPass[indexPath.row] * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
                cell.setLabel.text = "\(repsToPass[indexPath.row]) reps at \(weight) lbs"
                cell.setDescription.text = "\(Int(percentagesToPass[indexPath.row]*100.0))% of your training max"
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
            //Index is wrong
            let weight = round((0.6 * liftsToPass[index].trainingMax)/roundTo!) * roundTo!
            cell.setLabel.text = "10 reps at \(weight) lbs"
            cell.setDescription.text = "60% of your training max"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as! SetCell
            //Need index to find out the assistance lifts
            var assistance = "Lat work"
            cell.setLabel.text = "10 reps of \(assistance)"
            cell.setDescription.isHidden = true
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
}

extension WeekVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PrCell
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameSegmentedControls()
        //Use segmented control to select the index of where the user last left off
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
    func countSetsOfAssistance(assistance: [String]) -> Int {
        var sets = 0
        for exercise in assistance{
            let setIndex = exercise.index(exercise.startIndex, offsetBy: exercise.count-2)
            sets += Int(String(exercise[setIndex]))!
        }
        return sets
    }
    
    
    func nameSegmentedControls(){
        let weekDayNumbers = [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7,
        ]
        
        var liftDays: [String] = []
        for lift in liftsToPass {
            liftDays.append(lift.day)
        }
        
        liftDays.sort(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7)})
        
        for i in 0..<liftDays.count {
            daysSegControl.setTitle(liftDays[i], forSegmentAt: i)
        }
        
    }
}
