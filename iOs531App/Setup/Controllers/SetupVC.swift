//
//  ViewController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import SQLite

extension SetupVC: EditValueCellDelegate {
    func valueChangedForField(index: Int, section: Int, value: Double) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: section)) as! EditValueCell
        
        var roundedValue: Double!
        if section == 1 {
            roundedValue = controller.updateTrainingMax(index: index, max: value)
        } else if section == 2 {
            roundedValue = controller.updateProgression(index: index, progression: value)
        }
        
        cell.updateField(num: roundedValue)
    }
    
}

class SetupVC: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var setupNavBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewModel
    var viewModel: SetupListViewModel {
        return controller.viewModel
    }
    
    lazy var controller: SetupController = {
        return SetupController()
    }()
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log.info("SetupVC view did load called.")
        
        //Adding done button to the rightbaritem of nav bar
        log.info("Done bar item being added to navigation item")
        setupNavBar.delegate = self
        let item = UINavigationItem(title: viewModel.navTitle)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBacktoMain))
        item.rightBarButtonItem = done
        setupNavBar.items = [item]
        
        
        log.info("ViewModel being populated")
        controller.populateViewModel()
        
    }
    
    //MARK: UINavigationBarDelegate methods
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    //MARK: Setup completion methods
    @objc func goBacktoMain(){
        controller.savePreferences()
        controller.setupDatabase()
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    //MARK: TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionVMs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionVMs[section].rowVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        log.info("Cell for row at being called for tableview")
        let sectionVM = viewModel.sectionVMs[indexPath.section]
        let rowVM = sectionVM.rowVMs[indexPath.row]
        let identifier = controller.cellIdentifier(for: rowVM)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowVM)
        }
        
        if identifier == "editValueCell" {
            let cell = cell as? EditValueCell
            cell?.delegate = self
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionVMs[section].headerTitle
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = viewModel.sectionVMs[indexPath.section]
        if sectionVM.rowVMs[indexPath.row] is ViewModelPressible {
            //Deselecting the row removes the gray fill of the cell. Also makes clicking the cell look more animated
            tableView.deselectRow(at: indexPath, animated: true)
            
            //If the user clicks on the row that is currently checked, don't do anything.
            if indexPath.row == controller.selectedRoundToIndex {
                return
            }
            
            /*Since we got past the check, we know that the user checked a different row. We take get the cell of the
             current row and set its accessory to checked. Then, we use the selectedRoundToIndex to make an indexpath
             to the old cell that is checked. Here, we just uncheck the old cell. Final step is to set the roundtoindex
             to the current indexpath's row.
             */
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
            
            let oldCell = tableView.cellForRow(at: IndexPath(row: controller.selectedRoundToIndex!, section: indexPath.section))
            oldCell?.accessoryType = .none
            
            controller.updateRoundToIndex(roundToIndex: indexPath.row)
        }
    }
}


