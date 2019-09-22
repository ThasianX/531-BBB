//
//  ViewController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

//Won't be using this for now. Felt like with the sliding decimal pad, it would be more intuitive for users to just tap out
////Extension for allowing users to exit out of decimal pad
//extension UITextField {
//
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        self.addHideinputAccessoryView()
//    }
//
//    func addHideinputAccessoryView(){
//        let toolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: 40))
//        //Fits the toolbar across the input accessory view. So you can see the gray separators and fill of the toolbar.
//
//        //Flexible space is used to make sure the done button is right aligned.
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
//
//        toolbar.setItems([flexibleSpace, doneButton], animated: true)
//
//        self.inputAccessoryView = toolbar
//    }
//}

extension SetupVC: TrainingMaxCellDelegate {
    func maxChangedForField(mainLift: Lift, max: Double) {
        let index = lifts.firstIndex(of: mainLift)
        let cell = tableView.cellForRow(at: IndexPath(row: index!, section: 1)) as! TrainingMaxCell
        let roundTo = roundValues[selectedRoundToIndex]
        let roundedNum = round(max/roundTo)*roundTo
        cell.liftMaxField.placeholder = "\(roundedNum) lb"
        cell.liftMaxField.text = ""
    }
}

extension SetupVC: ProgressionCellDelegate {
    func progressionChangedForField(mainLift: Lift, progression: Double) {
        let index = lifts.firstIndex(of: mainLift)
        let cell = tableView.cellForRow(at: IndexPath(row: index!, section: 2)) as! ProgressionCell
        let roundTo = roundValues[selectedRoundToIndex]
        let roundedNum = round(progression/roundTo)*roundTo
        cell.progressionField.placeholder = "\(roundedNum) lb"
        cell.progressionField.text = ""
    }
}

class SetupVC: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var setupNavBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Table data sources
    let roundValues : [Double] = [2.5, 5, 10]
    
    //Index used for tracking which index of round to is currently checked
    var selectedRoundToIndex = 1
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
                    if let text = cell.liftMaxField.placeholder{
                        let num = text.dropLast(3)
                        let max = Double(num)
                        lifts[row].trainingMax = max!
                    }
                } else if section==2{
                    let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! ProgressionCell
                    if let text = cell.progressionField.placeholder{
                        let num = text.dropLast(3)
                        let progression = Double(num)
                        lifts[row].progression = progression!
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
            defaults.set(roundValues[selectedRoundToIndex], forKey: "roundTo")
            for lift in lifts {
                print("\(lift.name) + \(lift.trainingMax) + \(lift.progression)")
            }
            print(roundValues[selectedRoundToIndex])
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
            return lifts.count
        } else {
            return lifts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: RoundToCell = tableView.dequeueReusableCell(withIdentifier: "roundToCell") as! RoundToCell
            cell.weightLabel?.text = "\(roundValues[indexPath.row]) lb"
            //Checks to see if the current row selected should be checked.
            if indexPath.row == selectedRoundToIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell: TrainingMaxCell = tableView.dequeueReusableCell(withIdentifier: "trainingMaxCell") as! TrainingMaxCell
            let lift = lifts[indexPath.row]
            cell.liftLabel?.text = lift.name
            cell.liftMaxField?.placeholder = "0 lb"
            cell.delegate = self
            cell.configureWithField(mainLift: lift)
            return cell
            
        } else {
            let cell: ProgressionCell = tableView.dequeueReusableCell(withIdentifier: "progressionCell") as! ProgressionCell
            let lift = lifts[indexPath.row]
            cell.progressionLiftLabel?.text = lift.name
            cell.progressionField?.placeholder = "\(lift.progression) lb"
            cell.delegate = self
            cell.configureWithField(mainLift: lift)
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
            
            let oldCell = tableView.cellForRow(at: IndexPath(row: selectedRoundToIndex, section: 0))
            oldCell?.accessoryType = .none
            
            selectedRoundToIndex = indexPath.row
        }
        
    }
}


