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
    private let name = Expression<String>("name")
    private let progression = Expression<Double>("progression")
    private let trainingMax = Expression<Double>("trainingMax")
    private let personalRecord = Expression<Int64>("personalRecord")
    private let dayString = Expression<String>("dayString")
    private let dayInt = Expression<Int64>("dayInt")
    private let bbbLiftId = Expression<Int64>("bbbLiftId")
    
    private let cachedLifts = Table("cachedLifts")
    
    private let assistanceCatalog = Table("assistanceCatalog")
    private let reps = Expression<Int64>("reps")
    private let sets = Expression<Int64>("sets")
    private let type = Expression<String>("type")
    
    private let overheadPressAssistance = Table("overheadPressAssistance")
    private let deadliftAssistance = Table("deadliftAssistance")
    private let benchPressAssistance = Table("benchPressAssistance")
    private let squatAssistance = Table("squatAssistance")
    
    private let cachedOverheadPressAssistance = Table("cachedOverheadPressAssistance")
    private let cachedDeadliftAssistance = Table("cachedDeadliftAssistance")
    private let cachedBenchPressAssistance = Table("cachedBenchPressAssistance")
    private let cachedSquatAssistance = Table("cachedSquatAssistance")
    
    private let programPercentages = Table("programPercentages")
    private let programName = Expression<String>("programName")
    private let w1d1 = Expression<Double>("w1d1")
    private let w1d2 = Expression<Double>("w1d2")
    private let w1d3 = Expression<Double>("w1d3")
    private let w2d1 = Expression<Double>("w2d1")
    private let w2d2 = Expression<Double>("w2d2")
    private let w2d3 = Expression<Double>("w2d3")
    private let w3d1 = Expression<Double>("w3d1")
    private let w3d2 = Expression<Double>("w3d2")
    private let w3d3 = Expression<Double>("w3d3")
    private let w4d1 = Expression<Double>("w4d1")
    private let w4d2 = Expression<Double>("w4d2")
    private let w4d3 = Expression<Double>("w4d3")
    
    private let prValues = Table("prValues")
    private let date = Expression<String>("date")
    private let pr = Expression<Int64>("pr")
    private let liftName = Expression<String>("liftName")
    
    private let cyclePrLabels = Table("cyclePrLabels")
    private let prLabel = Expression<String>("prLabel")
    private let week = Expression<String>("week")
    private let liftId = Expression<Int64>("liftId")
    
    
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
            
            log.info("Creating cached lifts table")
            try db!.run(cachedLifts.create(ifNotExists: true) { table in
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
                table.column(id, primaryKey: .autoincrement)
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
            
            log.info("Creating cached overhead Press assistance table")
            try db!.run(cachedOverheadPressAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating cached deadlift assistance table")
            try db!.run(cachedDeadliftAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating cached bench Press assistance table")
            try db!.run(cachedBenchPressAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating cached squat assistance table")
            try db!.run(cachedSquatAssistance.create(ifNotExists: true) { table in
                table.column(id, references: assistanceCatalog, id)
            })
            
            log.info("Creating program percentages table")
            try db!.run(programPercentages.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(programName)
                table.column(w1d1)
                table.column(w1d2)
                table.column(w1d3)
                table.column(w2d1)
                table.column(w2d2)
                table.column(w2d3)
                table.column(w3d1)
                table.column(w3d2)
                table.column(w3d3)
                table.column(w4d1)
                table.column(w4d2)
                table.column(w4d3)
                })
            
            log.info("Creating pr values table")
            try db!.run(prValues.create(ifNotExists: true) {
                table in
                table.column(id, primaryKey: .autoincrement)
                table.column(date, unique: true)
                table.column(pr)
                table.column(liftName)
            })
            
            log.info("Creating cycle pr values table")
            try db!.run(cyclePrLabels.create(ifNotExists: true) {
                table in
                table.column(id, primaryKey: .autoincrement)
                table.column(prLabel)
                table.column(week)
                table.column(liftId)
                table.unique(week, liftId)
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
                lifts.append(Lift(id: lift[id], name: lift[name], progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId]))
            }
        } catch {
            log.error("Select failed")
        }
        
        return lifts
    }
    
    func getOrderedCachedLifts() -> [Lift]{
        var lifts = [Lift]()
        let orderedTable = cachedLifts.order(dayInt.asc)
        
        do {
            for lift in try db!.prepare(orderedTable) {
                lifts.append(Lift(id: lift[id], name: lift[name], progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId]))
            }
        } catch {
            log.error("getOrderedCachedLifts failed: \(error)")
        }
        
        return lifts
    }
    
    func cacheLifts() {
        do {
            for lift in try db!.prepare(mainLifts) {
                let insert = cachedLifts.insert(or: .replace, id <- lift[id], name <- lift[name], progression <- lift[progression], trainingMax <- lift[trainingMax], personalRecord <- lift[personalRecord], dayString <- lift[dayString], dayInt <- lift[dayInt], bbbLiftId <- lift[bbbLiftId])
                log.info("AddLift SQL: \(insert.asSQL())")
                try db!.run(insert)
            }
        } catch {
            log.error("cacheLifts failed: \(error)")
        }
    }
    
    func getCachedLift(cid: Int64) -> Lift? {
        let query = cachedLifts.filter(id == cid)
        log.debug("GetLift SQL: \(query.asSQL())")
        var resultLift: Lift?
        do {
            let lift = try db!.pluck(query)!
            resultLift = Lift(id: lift[id], name: lift[name], progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId])
        } catch {
            log.error("Get lift failed: \(error)")
        }
        return resultLift
    }
    
    func cacheAssistanceExercises(){
        do {
            try db!.run(cachedOverheadPressAssistance.delete())
            for assistance in try db!.prepare(overheadPressAssistance) {
                let insert = cachedOverheadPressAssistance.insert(id <- assistance[id])
                log.info("cacheAssistanceExercises SQL: \(insert.asSQL())")
                try db!.run(insert)
            }
            
            try db!.run(cachedDeadliftAssistance.delete())
            for assistance in try db!.prepare(deadliftAssistance) {
                let insert = cachedDeadliftAssistance.insert(id <- assistance[id])
                log.info("cacheAssistanceExercises SQL: \(insert.asSQL())")
                try db!.run(insert)
            }
            
            try db!.run(cachedBenchPressAssistance.delete())
            for assistance in try db!.prepare(benchPressAssistance) {
                let insert = cachedBenchPressAssistance.insert(id <- assistance[id])
                log.info("cacheAssistanceExercises SQL: \(insert.asSQL())")
                try db!.run(insert)
            }
            
            try db!.run(cachedSquatAssistance.delete())
            for assistance in try db!.prepare(squatAssistance) {
                let insert = cachedSquatAssistance.insert(id <- assistance[id])
                log.info("cacheAssistanceExercises SQL: \(insert.asSQL())")
                try db!.run(insert)
            }
        } catch {
            log.error("cacheAssistanceExercises failed: \(error)")
        }
    }
    
    func getCachedAssistanceExercisesForLift(cid: Int64) -> [Assistance]{
        var assistance = [Assistance]()
        
        do {
            let assistanceTable = getCachedTableForId(id: cid)
            for row in try db!.prepare(assistanceTable) {
                let query = assistanceCatalog.filter(id == row[id])
                let exercise = try db!.pluck(query)!
                assistance.append(Assistance(id: exercise[id], name: exercise[name], reps: exercise[reps], sets: exercise[sets], type: exercise[type]))
            }
        } catch {
            log.error("getCachedAssistanceExercisesForLift failed: \(error)")
        }
        
        return assistance
    }
    
    func getLift(cid: Int64) -> Lift? {
        let query = mainLifts.filter(id == cid)
        log.debug("GetLift SQL: \(query.asSQL())")
        var resultLift: Lift?
        do {
            let lift = try db!.pluck(query)!
            resultLift = Lift(id: lift[id], name: lift[name], progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId])
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
            resultLift = Lift(id: lift[id], name: lift[name], progression: lift[progression], trainingMax: lift[trainingMax], personalRecord: lift[personalRecord], dayString: lift[dayString], dayInt: lift[dayInt], bbbLiftId: lift[bbbLiftId])
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
            log.error("Delete failed")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cprogression: Double) -> Bool {
        var result: Bool = false
        var lift = mainLifts.filter(id == cid)
        do {
            var update = lift.update(progression <- cprogression)
            if try db!.run(update) > 0 {
                result = true
            }
            
            lift = cachedLifts.filter(id == cid)
            update = lift.update(progression <- cprogression)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            log.error("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, ctrainingMax: Double) -> Bool {
        var result: Bool = false
        var lift = mainLifts.filter(id == cid)
        do {
            var update = lift.update(trainingMax <- ctrainingMax)
            if try db!.run(update) > 0 {
                result = true
            }
            
            lift = cachedLifts.filter(id == cid)
            update = lift.update(trainingMax <- ctrainingMax)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            log.error("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cdayString: String, cdayInt: Int64) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        do {
            let update = lift.update(dayString <- cdayString, dayInt <- cdayInt)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            log.error("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cbbbLiftId: Int64) -> Bool {
        var result: Bool = false
        let lift = mainLifts.filter(id == cid)
        do {
            let update = lift.update(bbbLiftId <- cbbbLiftId)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            log.error("Update failed: \(error)")
        }
        
        return result
    }
    
    func updateLift(cid: Int64, cpersonalRecord: Int64) -> Bool {
        var result: Bool = false
        let lift = cachedLifts.filter(id == cid)
        do {
            let update = lift.update(personalRecord <- cpersonalRecord)
            if try db!.run(update) > 0 {
                result = true
            }
        } catch {
            log.error("Update failed: \(error)")
        }
        
        return result
    }
    
    func getAssistanceExercisesForLift(cid: Int64) -> [Assistance]{
        var assistance = [Assistance]()
        
        do {
            let assistanceTable = getTableForId(id: cid)
            for row in try db!.prepare(assistanceTable) {
                let query = assistanceCatalog.filter(id == row[id])
                let exercise = try db!.pluck(query)!
                assistance.append(Assistance(id: exercise[id], name: exercise[name], reps: exercise[reps], sets: exercise[sets], type: exercise[type]))
            }
        } catch {
            log.error("getAssistanceExercisesForLift failed: \(error)")
        }
        
        return assistance
    }
    
    func getAssistanceCatalog() -> [Assistance]{
        var catalog = [Assistance]()
        
        do {
            for exercise in try db!.prepare(self.assistanceCatalog) {
                catalog.append(Assistance(id: exercise[id], name: exercise[name], reps: exercise[reps], sets: exercise[sets], type: exercise[type]))
            }
        } catch {
            log.error("getAssistanceCatalog failed: \(error)")
        }
        
        return catalog
    }
    
    func getAssistanceIdsForLift(cid: Int64) -> [Int64] {
        var assistanceIds = [Int64]()
        let table = getTableForId(id: cid)
        
        do {
            for row in try db!.prepare(table){
                assistanceIds.append(row[id])
            }
        } catch {
            log.error("Failed to get assistance ids for lift: \(error)")
        }
        
        return assistanceIds
        
    }
    
    //updates the selected exercises table for given lift
    func addAssistanceForLift(cid: Int64, assistanceId: Int64){
        let table = getTableForId(id: cid)
        do {
            let insert = table.insert(id <- assistanceId)
            log.info("Addassistanceforlift SQL: \(insert.asSQL())")
            try db!.run(insert)
        } catch {
            log.error("Could not add assistance for lift: \(error)")
        }
        log.info("Assistance id \(assistanceId) successfully added")
    }
    
    func removeAssistanceForLift(cid: Int64, assistanceId: Int64){
        let table = getTableForId(id: cid)
        do {
            let row = table.filter(id == assistanceId)
            try db!.run(row.delete())
        } catch {
            log.error("Could not delete assistance for lift: \(error)")
        }
        log.info("Assistance id \(assistanceId) successfully deleted")
    }
    
    func addAssistanceForCatalog(assistance: Assistance)-> Int64{
        var id: Int64!
        do {
            let rowId = try db!.run(assistanceCatalog.insert(name <- assistance.name, reps <- assistance.reps, sets <- assistance.sets, type <- assistance.type))
            log.info("Addassistanceforlift inserted id: \(rowId)")
            id = rowId
        } catch {
            log.error("Insertion failed: \(error)")
        }
        return id
    }
    
    func getPercentagesForProgram(name: String) -> ProgramPercentages{
        var percentages: ProgramPercentages?
        do {
            let row = programPercentages.filter(name == programName)
            let program = try db!.pluck(row)!
            percentages = ProgramPercentages(id: program[id], name: name, w1d1: program[w1d1], w1d2: program[w1d2], w1d3: program[w1d3], w2d1: program[w2d1], w2d2: program[w2d2], w2d3: program[w2d3], w3d1: program[w3d1], w3d2: program[w3d2], w3d3: program[w3d3], w4d1: program[w4d1], w4d2: program[w4d2], w4d3: program[w4d3])
        } catch {
            log.error("Could not get percentages for program \(name): \(error)")
        }
        return percentages!
    }
    
    func insertProgramPercentage(percentages: ProgramPercentages){
        do {
            let insert = programPercentages.insert(or: .replace, programName <- percentages.name, w1d1 <- percentages.w1d1, w1d2 <- percentages.w1d2, w1d3 <- percentages.w1d3, w2d1 <- percentages.w2d1, w2d2 <- percentages.w2d2, w2d3 <- percentages.w2d3, w3d1 <- percentages.w3d1, w3d2 <- percentages.w3d2, w3d3 <- percentages.w3d3, w4d1 <- percentages.w4d1, w4d2 <- percentages.w4d2, w4d3 <- percentages.w4d3)
            log.info("insertProgramPercentages SQL: \(insert)")
            try db!.run(insert)
        } catch {
            log.error("Unable to insert program percentages: \(error)")
        }
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
    
    private func getCachedTableForId(id: Int64) -> Table{
        log.debug("Finding table with id: \(id)")
        switch id {
        case 0:
            log.debug("Returning cached overhead press table - 0")
            return cachedOverheadPressAssistance
        case 1:
            log.debug("Returning cached deadlift table - 1")
            return cachedDeadliftAssistance
        case 2:
            log.debug("Returning cached bench press table - 2")
            return cachedBenchPressAssistance
        case 3:
            log.debug("Returning cached squat table - 3")
            return cachedSquatAssistance
        default:
            log.error("Could not get table with given ID")
            fatalError()
        }
    }
    
    func addPr(cdate: String, cpr: Int64, cname: String){
        do {
            let insert = prValues.insert(or: .replace, date <- cdate, pr <- cpr, liftName <- cname)
            log.info("addPR SQL: \(insert)")
            let rowid = try db!.run(insert)
            log.info("Inserted row at \(rowid) for prValues table")
            
            for row in try db!.prepare(prValues){
                log.info("\(row[id]) + \(row[liftName]) + \(row[date]) + \(row[pr])")
            }
            
        } catch {
            log.info("Insertion failed: \(error)")
        }
    }
    
    func getPrs() -> [PersonalRecord]{
        var prs = [PersonalRecord]()
        
        do {
            for prObj in try db!.prepare(self.prValues) {
                prs.append(PersonalRecord(date: prObj[date], reps: prObj[pr], liftName: prObj[liftName]))
            }
        } catch {
            
            log.error("getPrs failed: \(error)")
        }
        
        return prs
    }
    
    func updateCyclePr(lift: Lift, cweek: String, cprLabel: String){
        do {
            var insert = cyclePrLabels.insert(or: .replace, prLabel <- cprLabel, week <- cweek, liftId <- lift.id!)
            try db!.run(insert)
            
            switch(cweek){
            case "Week 1":
                insert = cyclePrLabels.insert(or: .replace, prLabel <- "Beat your personal record of \(lift.personalRecord) reps", week <- "Week 2", liftId <- lift.id!)
                try db!.run(insert)
                insert = cyclePrLabels.insert(or: .replace, prLabel <- "Beat your personal record of \(lift.personalRecord) reps", week <- "Week 3", liftId <- lift.id!)
                try db!.run(insert)
            case "Week 2":
                insert = cyclePrLabels.insert(or: .replace, prLabel <- "Beat your personal record of \(lift.personalRecord) reps", week <- "Week 3", liftId <- lift.id!)
                try db!.run(insert)
            default:
                return
            }
        } catch {
            log.info("Insertion failed: \(error)")
        }
        
        do {
            log.info("Current state of cyclePrLabels table:")
            for row in try db!.prepare(cyclePrLabels){
                log.debug("Pr Label: \(row[prLabel]). Week: \(row[week]). LiftId: \(row[liftId])")
            }
        } catch {
            log.error(error)
        }
        
    }
    
    func resetCyclePrLabels(){
        do{
            try db!.run(cyclePrLabels.delete())
            let weeks = ["Week 1", "Week 2", "Week 3"]
            let lifts = getOrderedCachedLifts()
            for weekNum in weeks {
                for lift in lifts {
                    let insert = cyclePrLabels.insert(prLabel <- "Beat your previous PR of 0 reps", week <- weekNum, liftId <- lift.id!)
                    log.info("addCyclePr SQL: \(insert)")
                    let rowid = try db!.run(insert)
                    log.info("Inserted row at \(rowid) for cyclePrLabels table")
                }
            }
            
            log.info("Current state of cyclePrLabels table:")
            for row in try db!.prepare(cyclePrLabels){
                log.debug("Pr Label: \(row[prLabel]). Week: \(row[week]). LiftId: \(row[liftId])")
            }
        } catch {
            log.error("resetCyclePrLabels failed: \(error)")
        }
    }
    
    func getPrLabel(cid: Int64, cweek: String) -> String {
        do {
            let row = cyclePrLabels.filter(liftId == cid).filter(week == cweek)
            let prRow = try db!.pluck(row)!
            return prRow[prLabel]
        } catch {
            log.error("getPrLabel failed: \(error)")
            fatalError()
        }
    }
    
    func incrementLifts(){
        do {
            for row in try db!.prepare(mainLifts){
                let updatedTrainingMax = row[trainingMax] + row[progression]
                let lift = mainLifts.filter(id == row[id])
                try db!.run(lift.update(trainingMax <- updatedTrainingMax))
            }
        } catch {
            log.error("Increment lifts failed: \(error)")
        }
        
    }
    
}
