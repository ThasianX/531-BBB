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
        log.info("Tableview number of rows in section called")
        return viewModel.rowVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowVM = viewModel.rowVMs[indexPath.row]
        let identifier = controller.cellIdentifier(for: rowVM)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowVM)
        }
        return cell!
    }
    
}

protocol AddExerciseVCDelegate: class {
    func sendExerciseBack(exercise: Assistance)
}

class AddExerciseVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: AddExerciseVCDelegate?
    
    //MARK: ViewModel
    var viewModel: AssistanceCatalogVM {
        return controller.viewModel
    }
    
    lazy var controller: AddExerciseController = {
        return AddExerciseController()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("AddExerciseVC view did load called")
        controller.prepareViewModel()
        
        self.preferredContentSize = controller.getPreferredContentSize()
    }
    
    //MARK: Button actions
    @IBAction func cancelPopover(_ sender: UIBarButtonItem) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addExercise(_ sender: UIBarButtonItem) {
        for i in 0..<viewModel.rowVMs.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? AssistanceInputCell
            controller.addInputs(input: (cell?.editTextField.text)!)
        }
        
        let assistance = controller.getAssistance()
        print("\(assistance) added to the assistance exercise catalog")
        delegate?.sendExerciseBack(exercise: assistance)
    }
    
}
