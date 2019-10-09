//
//  AssistanceCatalogVM.swift
//  iOs531App
//
//  Created by Kevin Li on 10/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class AssistanceCatalogController {
    var lift: Lift!
    var index: Int!
    var assistanceCatalog: [Assistance]!
    var selectedExercisesId: [Int64]!
    
    let viewModel: AssistanceCatalogVM
    let db: CycleDb
    
    init(viewModel: AssistanceCatalogVM = AssistanceCatalogVM()){
        self.viewModel = viewModel
        
        log.info("Grabbing database instance")
        db = CycleDb.instance
        
        populateAssistanceCatalog()
        
    }
    
    private func populateAssistanceCatalog(){
        log.info("Populating assistance catalog")
        assistanceCatalog = db.getAssistanceCatalog()
        log.debug("Assistance catalog values: \(assistanceCatalog!)")
    }
    
    private func populateSelectedCatalog(){
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
}
