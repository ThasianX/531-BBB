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
    
    private let assistanceCatalog = Table("assistanceCatalog")
    private let reps = Expression<Double>("reps")
    private let sets = Expression<Double>("sets")
    private let type = Expression<String>("type")
    
    private let overheadPressAssistance = Table("overheadPressAssistance")
    private let deadliftAssistance = Table("deadliftAssistance")
    private let benchPressAssistance = Table("benchPressAssistance")
    private let squatAssistance = Table("squatAssistance")
    private let liftsAssistance = Table("liftsAssistance")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        log.info("Database initializing")
        
        do {
            db = try Connection("\(path)/CycleDb.sqlite3")
            createTables()
        } catch {
            db = nil
            log.error("Unable to open database")
        }
        
        
    }
    
    func createTables(){
        do {
            log.info("Creating main lifts table")
            try db!.run(mainLifts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(progression)
                table.column(trainingMax)
                table.column(personalRecord)
                table.column(dayString)
                table.column(dayInt)
                table.column(bbbLiftId)
            })
            
            log.info("Creating assistance catalog table")
            try db!.run(assistanceCatalog.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(reps)
                table.column(sets)
                table.column(type)
            })
            
            log.info("Creating overhead Press assistance table")
            try db!.run(overheadPressAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating deadlift assistance table")
            try db!.run(deadliftAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating bench Press assistance table")
            try db!.run(benchPressAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating squat assistance table")
            try db!.run(squatAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating lifts assistance table")
            try db!.run(liftsAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
        } catch {
            log.error("Unable to create table: \(error)")
        }
    }
    
    func addLift(lift: Lift){
        do {
            let insert = mainLifts.insert(id <- lift.id!, name <- lift.name, progression <- lift.progression, trainingMax <- lift.trainingMax, personalRecord <- lift.personalRecord, dayString <- lift.dayString, dayInt <- lift.dayInt, bbbLiftId <- lift.bbbLiftId)
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
                lifts.append(Lift(id: lift[id], name: lift[name]!, progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId]))
            }
        } catch {
            log.error("Select failed")
        }
        
        return lifts
    }
    
    func getLift(cid: Int64) -> Lift? {
        let query = mainLifts.filter(id == cid)
        log.debug("GetLift SQL: \(query.asSQL())")
        var resultLift: Lift?
        do {
            let lift = try db!.pluck(query)!
            resultLift = Lift(id: lift[id], name: lift[name]!, progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId])
        } catch {
            log.error("Get lift failed: \(error)")
        }
        return resultLift
    }
    
    func getLift(cname: String) -> Lift? {
        let query = mainLifts.filter(cname == name)
        var resultLift: Lift?
        do {
            let lift = try db!.pluck(query)!
            resultLift = Lift(id: lift[id], name: lift[name]!, progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId])
        } catch {
            log.error("Get lift failed: \(error)")
        }
        return resultLift
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
    
    func updateLift(cid: Int64, ctrainingMax: Double) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        do {
            let update = lift.update(trainingMax <- ctrainingMax)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cdayString: String, cdayInt: Int64) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        log.info("UpdateLift SQL: \(lift.asSQL())")
        do {
            let update = lift.update(dayString <- cdayString, dayInt <- cdayInt)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cbbbLiftId: Int64) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        log.info("UpdateLift SQL: \(lift.asSQL())")
        do {
            let update = lift.update(bbbLiftId <- cbbbLiftId)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return result
    }
    
    func getAssistanceExercisesForLift(cid: Int64) -> String{
        var assistanceExercises = ""
        
        do {
            let assistanceTable = getTableForId(id: cid)
            for exercises in try db!.prepare(assistanceTable) {
                assistanceExercises.append("\(exercises[name]!) - \(exercises[reps])x\(exercises[sets])\n")
            }
        } catch {
            print("Select failed")
        }
        
        return assistanceExercises
    }
    
    private func getTableForId(id: Int64) -> Table{
        log.debug("Finding table with id: \(id)")
        switch id {
        case 0:
            log.debug("Returning overhead press table - 0")
            return overheadPressAssistance
        case 1:
            log.debug("Returning deadlift table - 1")
            return deadliftAssistance
        case 2:
            log.debug("Returning bench press table - 2")
            return benchPressAssistance
        case 3:
            log.debug("Returning squat table - 3")
            return squatAssistance
        default:
            log.error("Could not get table with given ID")
            fatalError()
        }
    }
    
}
