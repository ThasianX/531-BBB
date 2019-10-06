//
//  CycleDb.swift
//  iOs531App
//
//  Created by Kevin Li on 10/3/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import SQLite
import UIKit

class CycleDb {
    static let instance = CycleDb()
    private let db: Connection?
    
    private let mainLifts = Table("mainLifts")
    //Will use both id and name
    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let progression = Expression<Double>("progression")
    private let trainingMax = Expression<Double>("trainingMax")
    private let personalRecord = Expression<Int64>("personalRecord")
    private let dayString = Expression<String>("dayString")
    private let dayInt = Expression<Int64>("dayInt")
    private let bbbLiftId = Expression<Int64>("bbbLiftId")
    private let assistanceExercisesId = Expression<Int64>("assistanceExercisesId")
    
    private let assistanceCatalog = Table("assistanceCatalog")
    private let reps = Expression<Double>("reps")
    private let sets = Expression<Double>("sets")
    private let type = Expression<String>("type")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            db = try Connection("\(path)/CycleDb.sqlite3")
            createTables()
        } catch {
            db = nil
            print("Unable to open database")
        }
    }
    
    func createTables(){
        do {
            try db!.run(mainLifts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(progression)
                table.column(trainingMax)
                table.column(personalRecord)
                table.column(dayString)
                table.column(dayInt)
                table.column(bbbLiftId)
                table.column(assistanceExercisesId)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addLift(lift: Lift){
        do {
            let insert = mainLifts.insert(name <- lift.name, progression <- lift.progression, trainingMax <- lift.trainingMax, personalRecord <- lift.personalRecord, dayString <- lift.dayString, dayInt <- lift.dayInt, bbbLiftId <- lift.bbbLiftId, assistanceExercisesId <- lift.assistanceExercisesId)
            log.info("AddLift SQL: \(insert.asSQL())")
            try db!.run(insert)
        } catch {
            log.error("Insert failed: \(error)")
        }
    }
    
    func getLifts() -> [Lift] {
        var lifts = [Lift]()
        
        do {
            for lift in try db!.prepare(self.mainLifts) {
                lifts.append(Lift(id: lift[id], name: lift[name]!, progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId], assistanceExercisesId: lift[assistanceExercisesId]))
            }
        } catch {
            print("Select failed")
        }
        
        return lifts
    }
    
    func deleteLift(cid: Int64) -> Bool{
        var result: Bool = false
        do {
            let lift = mainLifts.filter(id == cid)
            try db!.run(lift.delete())
            result = true
        } catch {
            print("Delete failed")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cprogression: Double) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        do {
            let update = lift.update(progression <- cprogression)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return result
    }
    
}
