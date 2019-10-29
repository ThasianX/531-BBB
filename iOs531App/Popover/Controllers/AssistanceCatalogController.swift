//
//  AssistanceCatalogVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

protocol AssistanceCatalogControllerDelegate {
    func assistanceSelectionComplete(index: Int)
}

class AssistanceCatalogController {
    var lift: Lift!
    var index: Int!
    var assistanceCatalog: [Assistance]!
    var selectedExercisesId: [Int64]!
    var delegate: AssistanceCatalogControllerDelegate?
    
    let viewModel: AssistanceCatalogVM
    let db: CycleDb
    
    init(viewModel: AssistanceCatalogVM = AssistanceCatalogVM()){
        self.viewModel = viewModel
        log.info("AssistanceCatalogVM aware of view did load call")
        
        log.info("Grabbing database instance")
        db = CycleDb.instance
    }
    
    func populateAssistanceCatalog(){
        log.info("Populating assistance catalog")
        assistanceCatalog = db.getAssistanceCatalog()
        log.debug("Assistance catalog values: \(assistanceCatalog!)")
    }
    
    func populateSelectedCatalog(){
        log.info("Populating selected catlog")
        selectedExercisesId = db.getAssistanceIdsForLift(cid: lift.id!)
        log.debug("Selected catalog values: \(selectedExercisesId!)")
    }
    
    func populateViewModel(){
        var rows = [RowViewModel]()
        var vm: RowViewModel?
        log.info("Populating assistanceViewModel")
        
        for exercise in assistanceCatalog {
            var checked = false
            if selectedExercisesId.contains(exercise.id){
                checked = true
            }
            let assistanceExerciseVM = AssistanceExerciseCellVM(assistance: exercise, isChecked: checked)
            
            vm = assistanceExerciseVM
            rows.append(vm!)
        }
        
        self.viewModel.rowVMs = rows
        log.debug("There are \(rows.count) rows")
    }
    
    //Returns the type of cell for tableview dequeue method
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        return "assistanceExerciseCell"
    }
    
    func updateSelectedExercise(indexPath: IndexPath) -> Bool{
        let vm = viewModel.rowVMs[indexPath.row] as? AssistanceExerciseCellVM
        
        let assistanceId = vm!.assistance.id
        
        if vm!.isChecked {
            vm?.isChecked = false
            if let index = selectedExercisesId.firstIndex(of: assistanceId) {
                selectedExercisesId.remove(at: index)
                db.removeAssistanceForLift(cid: lift.id!, assistanceId: vm!.assistance.id)
            }
            return false
        } else {
            vm?.isChecked = true
            //Not in order but fine
            selectedExercisesId.append(assistanceId)
            db.addAssistanceForLift(cid: lift.id!, assistanceId: vm!.assistance.id)
            return true
        }
    }
    
    func addAssistanceForCatalog(exercise: Assistance){
        assistanceCatalog.append(exercise)
        
        var vm: RowViewModel?
        
        let assistanceExerciseVM = AssistanceExerciseCellVM(assistance: exercise, isChecked: false)
        
        vm = assistanceExerciseVM
        
        viewModel.rowVMs.append(vm!)
    }
    
    func selectionDone(){
        delegate?.assistanceSelectionComplete(index: index)
    }
}
