//
//  CycleVC.swift
//  iOs531App
//
//  Created by Kevin Li on 9/13/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension CycleVC: UICollectionViewDataSource {
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
    
    var viewModel: CycleVM {
        return controller.viewModel
    }
    
    lazy var controller: CycleController = {
        return CycleController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("CycleVC viewdidload called")
        controller.populateViewModel()
    }

    //MARK: Bar Button Action
    @IBAction func resetCycle(_ sender: UIBarButtonItem) {
        controller.resetCycle()
        collectionView.reloadSections(IndexSet(integer: 0))
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
