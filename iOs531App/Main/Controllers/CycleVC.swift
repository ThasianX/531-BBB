//
//  CycleVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/13/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension CycleVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowVms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowVM = viewModel.rowVms[indexPath.row]
        let identifier = controller.cellIdentifier(rowVM: rowVM)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowVM)
        }
        
        return cell
    }
}

extension CycleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return controller.setSelectedWeek(week: indexPath.row)
    }
}

extension CycleVC: WeekVCDelegate {
    func workoutComplete() {
        controller.refreshCheckBoxState()
        controller.refreshSelectedRow()
        collectionView.reloadItems(at: [IndexPath(row: controller.selectedIndex!, section: 0)])
    }
}


class CycleVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completeCycleButton: UIButton!
    
    var viewModel: CycleVM {
        return controller.viewModel
    }
    
    @IBAction func completeCycle(_ sender: UIButton) {
        let alert = UIAlertController(title: "Complete cycle", message: "Completing will increment all lifts and continue to the next cycle", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.controller.completeCycle()
            self.collectionView.reloadSections(IndexSet(integer: 0))
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(alert, animated: true)
    }
    
    lazy var controller: CycleController = {
        return CycleController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("CycleVC viewdidload called")
        controller.populateViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controller.refreshCycleData()
    }

    //MARK: Bar Button Action
    @IBAction func resetCycle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reset cycle", message: "Resetting will restart the current cycle", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.controller.resetCycle()
            self.collectionView.reloadSections(IndexSet(integer: 0))
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(alert, animated: true)
        
    }

    //MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeek" {
            print("Show week segue called")
            let vc = segue.destination as! WeekVC
            controller.prepareData(vc: vc)
            vc.delegate = self
        }
    }
}
