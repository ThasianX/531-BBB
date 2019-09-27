//
//  AssistanceCatalogController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import Foundation


extension AssistanceCatalogVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension AssistanceCatalogVC: AddExerciseVCDelegate {
    func sendExerciseBack(exercise: String) {
        print("Before catalog: ")
        print(assistanceCatalog)
        assistanceCatalog.append(exercise)
        print("After catalog: ")
        print(assistanceCatalog)
        save()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AssistanceCatalogVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assistanceCatalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assistanceExerciseCell") as! AssistanceExerciseCell
        let exercise = assistanceCatalog[indexPath.row]
        
        let repsIndex = exercise.range(of: " Reps: ")
        let start = exercise.index(exercise.startIndex, offsetBy: 6)
        let exerciseName = String(exercise[start..<repsIndex!.lowerBound])
        print("Exercise name: \(exerciseName)")
        
        let setsIndex = exercise.range(of: " Sets: ")
        let reps = String(exercise[repsIndex!.upperBound..<setsIndex!.lowerBound])
        print("Exercise number of reps: \(reps)")
        
        let sets = String(exercise[setsIndex!.upperBound..<exercise.endIndex])
        print("Exercise number of sets: \(sets)")
  
        cell.exerciseLabel.text = exerciseName
        cell.descriptionLabel.text = "\(reps) reps - \(sets) sets"
//
//        let parts = exercise.split(separator: " ")
//        if parts.count != 0 {
//            cell.exerciseLabel.text = String(parts[1])
//            cell.descriptionLabel.text = "\(String(parts[3])) reps - \(String(parts[5])) sets"
//        }
        if selectedExercises.contains(exercise) {
            print("Cell at \(indexPath.row) checked")
            cell.accessoryType = .checkmark
        } else {
            print("Cell at \(indexPath.row) none")
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! AssistanceExerciseCell
        if cell.accessoryType == .checkmark {
            let checkedExercise = assistanceCatalog[indexPath.row]
            let index = selectedExercises.firstIndex(of: checkedExercise)
            selectedExercises.remove(at: index!)
            cell.accessoryType = .none
        } else {
            let checkedExercise = assistanceCatalog[indexPath.row]
            selectedExercises.append(checkedExercise)
            cell.accessoryType = .checkmark
        }
        
        liftToPass.assistanceLifts = selectedExercises
        delegate?.assistanceExerciseSelected(lift: liftToPass, index: indexToPass)
    }
}

protocol AssistanceCatalogVCDelegate: class {
    func assistanceSelectionComplete(index: Int)
    func assistanceExerciseSelected(lift: Lift, index: Int)
}

class AssistanceCatalogVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var liftLabel: UILabel!
    
    //MARK: Data
    var assistanceCatalog: [String] = []
    var selectedExercises: [String] = []
    var liftToPass: Lift!
    var indexToPass: Int!
    
    weak var delegate: AssistanceCatalogVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assistanceCatalog = UserDefaults.standard.value(forKey: "assistanceCatalog") as! [String]
        liftLabel.text = liftToPass.name
        selectedExercises = liftToPass.assistanceLifts
        print("Selected exercises: \(selectedExercises)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.assistanceSelectionComplete(index: indexToPass)
    }

    //MARK: Button actions
    @IBAction func displayPopover(_ sender: UIBarButtonItem) {
        //Here I load the view controller that will be used to display the popover
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "AddExerciseVC") as! AddExerciseVC
        addVC.delegate = self
        
        addVC.modalPresentationStyle = .popover
        addVC.popoverPresentationController?.barButtonItem = sender
        addVC.popoverPresentationController?.delegate = self
        
        present(addVC, animated: true, completion: nil)
    }
    
    //MARK: Helper methods
    func save(){
        UserDefaults.standard.set(assistanceCatalog, forKey: "assistanceCatalog")
    }
    
}
