//
//  AddExerciseVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension AddExerciseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assistanceInputCell") as! AssistanceInputCell
        cell.editTextField.placeholder = placeholderText[indexPath.row]
        cell.inputLabel.text = cellTitles[indexPath.row]
        
        if cellTitles[indexPath.row] == "Name" {
            cell.editTextField.keyboardType = .default
        } else {
            cell.editTextField.keyboardType = .numberPad
        }
        
        return cell
    }
    
}

protocol AddExerciseVCDelegate: class {
    func sendExerciseBack(exercise: String)
}

class AddExerciseVC: UIViewController {
    
    //MARK: Data
    let cellTitles = ["Name", "Reps", "Sets"]
    let placeholderText = ["Just", "Do", "It"]
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: AddExerciseVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Button actions
    @IBAction func cancelPopover(_ sender: UIBarButtonItem) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addExercise(_ sender: UIBarButtonItem) {
        var exercise = ""
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AssistanceInputCell
        if cell.editTextField.text == "" {
            
        }
        
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section){
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! AssistanceInputCell
                if let text = cell.editTextField.text {
                    exercise += "\(cellTitles[row]): \(text) "
                }
            }
        }
        print("\(exercise)added to the assistance exercise catalog")
        delegate?.sendExerciseBack(exercise: exercise)
    }
    
}
