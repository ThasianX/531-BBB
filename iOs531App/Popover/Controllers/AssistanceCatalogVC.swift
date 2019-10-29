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
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension AssistanceCatalogVC: AddExerciseVCDelegate {
    func sendExerciseBack(exercise: Assistance) {
        controller.addAssistanceForCatalog(exercise: exercise)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AssistanceCatalogVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.info("Row count is \(viewModel.rowVMs.count)")
        return viewModel.rowVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.rowVMs[indexPath.row]
        let identifier = controller.cellIdentifier(for: row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)

        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: row)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if controller.updateSelectedExercise(indexPath: indexPath) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
    }
}

class AssistanceCatalogVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var liftLabel: UILabel!
    
    //MARK: Data
    
    //MARK: ViewModel
    var viewModel: AssistanceCatalogVM {
        return controller.viewModel
    }
    
    lazy var controller: AssistanceCatalogController = {
        return AssistanceCatalogController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("AssistanceCatalogVC view did load called")
        liftLabel.text = "Select exercises for \(controller.lift.name)"
        controller.populateAssistanceCatalog()
        controller.populateSelectedCatalog()
        controller.populateViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        controller.selectionDone()
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
    
}

