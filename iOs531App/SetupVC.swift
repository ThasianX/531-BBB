//
//  ViewController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class SetupVC: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var setupNavBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Table data sources
    let roundValues : [Double] = [2.5, 5, 10]
    let liftNames : [String] = ["Overhead Press", "Deadlift", "Bench Press", "Squat"]
    
    var chosenRoundTo = 2.5
    var lifts : [Lift] = []
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar.delegate = self
        
        let item = UINavigationItem(title: "Setup")
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBacktoMain))
        item.rightBarButtonItem = done
        
        setupNavBar.items = [item]
        
        lifts.append(Lift(name: "Overhead Press", progression: 5, trainingMax: 0, personalRecord: 0, day: "Monday", bbbLift: "Overhead Press", assistanceLift: "Lat Pulldowns"))
        lifts.append(Lift(name: "Deadlift", progression: 10, trainingMax: 0, personalRecord: 0, day: "Tuesday", bbbLift: "Deadlift", assistanceLift: "Ab work"))
        lifts.append(Lift(name: "Bench Press", progression: 5, trainingMax: 0, personalRecord: 0, day: "Thursday", bbbLift: "Bench Press", assistanceLift: "Lat Pulldowns"))
        lifts.append(Lift(name: "Squat", progression: 10, trainingMax: 0, personalRecord: 0, day: "Friday", bbbLift: "Squat", assistanceLift: "Ab work"))
    }
    //MARK: UINavigationBarDelegate methods
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    //MARK: Setup completion methods
    @objc func goBacktoMain(){
        UserDefaults.standard.set(true, forKey: "setup")
        for section in 1..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section){
                if section==1 {
                    let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! TrainingMaxCell
                    if let num = cell.liftMaxField.text, let max = Double(num){
                        lifts[row].trainingMax = max
                    }
                } else if section==2{
                    let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! ProgressionCell
                    if let num = cell.progressionField.text, let progression = Double(num){
                        lifts[row].progression = progression
                    }
                }
            }
            
        }
        save()
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: lifts, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "lifts")
            defaults.set(chosenRoundTo, forKey: "roundTo")
        }
    }
    
    //MARK: TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section==0 {
            return roundValues.count
        } else if section==1 {
            return liftNames.count
        } else {
            return liftNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell: RoundToCell = tableView.dequeueReusableCell(withIdentifier: "roundToCell") as! RoundToCell
            cell.weightLabel?.text = "\(roundValues[indexPath.row]) lb"
            return cell
        } else if indexPath.section == 1 {
            let cell: TrainingMaxCell = tableView.dequeueReusableCell(withIdentifier: "trainingMaxCell") as! TrainingMaxCell
            cell.liftLabel?.text = liftNames[indexPath.row]
            cell.liftMaxField?.placeholder = "0 lb"
            return cell
        } else {
            let cell: ProgressionCell = tableView.dequeueReusableCell(withIdentifier: "progressionCell") as! ProgressionCell
            cell.progressionLiftLabel?.text = liftNames[indexPath.row]
            cell.progressionField?.placeholder = "\(lifts[indexPath.row].progression) lb"
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            return "Round to smallest weight"
        } else if section==1{
            return "Training maxes"
        } else {
            return "Weight progression"
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==0{
            chosenRoundTo = roundValues[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section==0 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        
    }
    

}
