//
//  WeekVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol WeekVCDelegate: class {
    func workoutComplete()
}

extension WeekVC: WeekControllerDelegate {
    func reloadPr(indexPath: IndexPath, timerOn: Bool) {
        if timerOn {
            performSegue(withIdentifier: "showTimer", sender: self)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension WeekVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionVms[section].rowVMs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionVms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionVms[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setVM = viewModel.sectionVms[indexPath.section].rowVMs[indexPath.row]
        let identifier = controller.cellIdentifier(vm: setVM, indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if let cell = cell as? SetConfigurable {
            cell.setup(setViewModel: setVM)
        }
        
        return cell!
    }
}

extension WeekVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        //update viewmodel and ui. cell accessory type
        if cell?.accessoryType == .checkmark {
            controller.setChecked(indexPath: indexPath, checked: false)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            if cell is AlertConfigurable{
                let alert = controller.setupPrAlert(indexPath: indexPath)
                self.present(alert, animated: true, completion: nil)
            } else {
                controller.setChecked(indexPath: indexPath, checked: true)
                if controller.timerEnabled(section: indexPath.section) {
                    controller.setupSetDescriptions(indexPath: indexPath)
                    performSegue(withIdentifier: "showTimer", sender: self)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
}

class WeekVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var daysSegControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: WeekVCDelegate?
    
    //Viewmodel
    var viewModel: WeekListVM {
        return controller.viewModel
    }
    
    lazy var controller: WeekController = {
       return WeekController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("WeekVC aware of viewdidload call")
        
        navigationItem.title = controller.navTitle
        controller.initializeSelectedDay()
        
        initSegmentedControl()
        
        controller.delegate = self
        controller.setupViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        log.info("viewWillDisappear called")
        delegate?.workoutComplete()
    }
    
    func initSegmentedControl(){
        log.info("initSegmentedControl called")
        for (i, day) in controller.getLiftDays().enumerated(){
            daysSegControl.setTitle(day, forSegmentAt: i)
        }
        daysSegControl.selectedSegmentIndex = controller.selectedDay
    }
    
    //MARK: Segmented Control Action
    @IBAction func showDay(_ sender: UISegmentedControl) {
        log.info("showDay called")
        controller.setSelectedDay(index: daysSegControl.selectedSegmentIndex)
        
        controller.setupViewModel()
        
        let range = 0..<controller.viewModel.sectionVms.count
        tableView.reloadSections(IndexSet(integersIn: range), with: .automatic)
    }
    
    //MARK: Helper methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimer" {
            let vc = segue.destination as! TimerVC
            controller.prepareData(vc: vc)
        }
    }
}
