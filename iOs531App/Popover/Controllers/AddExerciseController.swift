//
//  AddExerciseController.swift
//  iOs531App
//
//  Created by Kevin Li on 10/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class AddExerciseController {
    
    private (set) var inputLabels: [String]!
    private (set) var viewModel: AssistanceCatalogVM
    private (set) var db: CycleDb
    private (set) var inputs: [String]!
    
    init(viewModel: AssistanceCatalogVM = AssistanceCatalogVM()) {
        self.viewModel = viewModel
        db = CycleDb.instance
        
        prepareOutputData()
    }
    
    private func prepareOutputData(){
        inputLabels = ["Name", "Reps", "Sets", "Type"]
        inputs = [String]()
    }
    
    func prepareViewModel(){
        var rowVms = [RowViewModel]()
        var vm: RowViewModel?
        
        for label in inputLabels {
            let assistanceInputVM = AssistanceInputCellVM(inputLabel: label)
            log.debug("AssistanceInputVM created with: inputLabel -  \(assistanceInputVM.inputLabel)")
            vm = assistanceInputVM
            rowVms.append(vm!)
        }
        
        viewModel.rowVMs = rowVms
        log.debug("There are \(rowVms.count) rows")
    }
    
    func cellIdentifier(for vm: RowViewModel) -> String {
        return "assistanceInputCell"
    }
    
    func getAssistance() -> Assistance{
        
        let assistance = Assistance(id: 0, name: inputs[0], reps: Int64(inputs[1])!, sets: Int64(inputs[2])!, type: inputs[3])
        
        let id = db.addAssistanceForCatalog(assistance: assistance)
        
        return Assistance(id: id, name: assistance.name
            , reps: assistance.reps, sets: assistance.sets, type: assistance.type)
    }
    
    func addInputs(input: String){
        inputs.append(input)
    }
    
    
}
