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
        //Change it back to 1
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekDisplayCell", for: indexPath) as! WeekDisplayCell
        cell.weekLabel.text = weekTitles[indexPath.row]
        cell.trainingPercentagesLabel.text = weekDescriptions[indexPath.row]
        //Filters the number of trues in the array
        let numberOfTrue = checkboxStates[indexPath.row].filter{$0}.count
        print("There are \(numberOfTrue) trues out in the array of  \(checkboxStates[indexPath.row]) \(checkboxStates[indexPath.row].count) booleans")
        let progress = Float(Double(numberOfTrue) / Double(checkboxStates[indexPath.row].count))
        print("Progress is \(100*progress)%")
        cell.progressView.setProgress(progress, animated: true)
        cell.progressViewLabel.text = "\(Int(100*progress))% complete"
        
        return cell
    }
}

extension CycleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedIndex = indexPath.row
        return true
    }
}

//extension CycleVC: WeekVCDelegate {
//    func setCheckedState(section: Int, index: Int, checked: Bool) {
//        switch section {
//        case 0:
//            checkboxStates[selectedIndex!][index] = checked
//        case 1:
//            checkboxStates[selectedIndex!][index+3] = checked
//        case 2:
//            checkboxStates[selectedIndex!][index+6] = checked
//        default:
//            checkboxStates[selectedIndex!][index+11] = checked
//        }
//
//        UserDefaults.standard.set(checkboxStates, forKey: "checkboxStates")
//    }
//
//    func workoutComplete() {
//        collectionView.reloadItems(at: [IndexPath(row: selectedIndex!, section: 0)])
//    }
//}


class CycleVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Data
    let weekTitles = ["Week 1", "Week 2", "Week 3", "Week 4"]
    let weekDescriptions = ["5/3/1 - 65% | 75% | 85%", "5/3/1 - 70% | 80% | 90%", "5/3/1 - 75% | 85% | 95%", "Deload - 40% | 50% | 60%"]
    let weekReps = [[5,5,5],[3,3,3], [5,3,1],[5,5,5]]
    var checkboxStates : [[Bool]]!
    var cachedLifts: [Lift]!
    let weekPercentages = [[0.65,0.75,0.85], [0.70,0.80,0.90], [0.75,0.85,0.95], [0.40,0.50,0.60]]
    var selectedIndex: Int?
    var assistanceForEachDay: [Int] = []
//    var assistanceChunks: [AssistanceChunk] = []
    
    override func viewDidLoad() {
//        let defaults = UserDefaults.standard
//        checkboxStates = defaults.value(forKey: "checkboxStates") as? [[Bool]]
//
//        if defaults.value(forKey: "notFirstCycle") != nil{
//            if let savedData = defaults.value(forKey: "cachedLifts") as? Data {
//                if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
//                    cachedLifts = decodedData
//                }
//            }
//
//            assistanceForEachDay = defaults.value(forKey: "assistanceForEachDay") as! [Int]
//            print(assistanceForEachDay)
//
//            let fetchedData = defaults.data(forKey: "assistanceChunks")!
//            assistanceChunks = try! PropertyListDecoder().decode([AssistanceChunk].self, from: fetchedData)
//            print(assistanceChunks)
//        } else {
//            defaults.set(true, forKey: "notFirstCycle")
//
//            if let savedData = defaults.value(forKey: "lifts") as? Data {
//                if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
//                    cachedLifts = decodedData
//                }
//            }
//
//            sortLiftsByDayAndCountAssistance()
//
//            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cachedLifts!, requiringSecureCoding: false){
//                defaults.set(savedData, forKey: "cachedLifts")
//            }
//
//            defaults.set(checkboxStates, forKey: "checkboxStates")
//            defaults.set(assistanceForEachDay, forKey: "assistanceForEachDay")
//
//            let assistanceChunkData = try! PropertyListEncoder().encode(assistanceChunks)
//            defaults.set(assistanceChunkData, forKey: "assistanceChunks")
//            print(assistanceChunks)
//        }
    }
    
    //MARK: Helper methods
//    private func sortLiftsByDayAndCountAssistance(){
//        var newLifts: [Lift] = []
//
//        let weekDayNumbers = [
//            "Sunday": 1,
//            "Monday": 2,
//            "Tuesday": 3,
//            "Wednesday": 4,
//            "Thursday": 5,
//            "Friday": 6,
//            "Saturday": 7,
//        ]
//
//        //Will be used to track number of assistance exercises
//        var assistanceCounter = 0
//
//        var liftDays: [String] = []
//        for lift in cachedLifts {
//            liftDays.append(lift.day)
//            var counter = 0
//            for exercise in lift.assistanceLifts {
//                let setsIndex = exercise.range(of: " Sets: ")
//                let endIndex = exercise.index(exercise.endIndex, offsetBy: -1)
//                let numOfAssistance =  Int(String(exercise[setsIndex!.upperBound..<endIndex]))!
//                counter += numOfAssistance
//                assistanceCounter += numOfAssistance
//
//                let repsIndex = exercise.range(of: " Reps: ")
//                let start = exercise.index(exercise.startIndex, offsetBy: 6)
//                let exerciseName = String(exercise[start..<repsIndex!.lowerBound])
//                let reps = Int(String(exercise[repsIndex!.upperBound..<setsIndex!.lowerBound]))!
//
//                for _ in 0..<numOfAssistance {
//                    assistanceChunks.append(AssistanceChunk(liftName: exerciseName, reps: reps))
//                }
//            }
//            assistanceForEachDay.append(counter)
//        }
//
//        liftDays.sort(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7)})
//
//        for day in liftDays {
//            var found = false
//            var i = 0
//            while !found {
//                if cachedLifts[i].day == day {
//                    newLifts.append(cachedLifts[i])
//                    cachedLifts.remove(at: i)
//                    found = true
//                }
//                i+=1
//            }
//        }
//
//        //Sorted lifts array - Days asc
//        cachedLifts = newLifts
//
//        //Appending the number of assistance exercises
//        for i in 0...3 {
//            for _ in 0..<assistanceCounter {
//                checkboxStates[i].append(false)
//            }
//        }
//    }
//
//    private func resetCheckedStatesAndAssistance(){
//
//        for i in 0...3 {
//            checkboxStates[i].removeAll()
//            for _ in 0..<44 {
//                checkboxStates[i].append(false)
//            }
//        }
//        assistanceForEachDay.removeAll()
//        assistanceChunks.removeAll()
//    }
//
//    //MARK: Bar Button Action
//    @IBAction func resetCycle(_ sender: UIBarButtonItem) {
//        let defaults = UserDefaults.standard
//
//        resetCheckedStatesAndAssistance()
//
//        if let savedData = defaults.value(forKey: "lifts") as? Data {
//            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
//                cachedLifts = decodedData
//            }
//        }
//
//        sortLiftsByDayAndCountAssistance()
//
//        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cachedLifts!, requiringSecureCoding: false){
//            defaults.set(savedData, forKey: "cachedLifts")
//        }
//
//        defaults.set(checkboxStates, forKey: "checkboxStates")
//        defaults.set(assistanceForEachDay, forKey: "assistanceForEachDay")
//
//        let assistanceChunkData = try! PropertyListEncoder().encode(assistanceChunks)
//        defaults.set(assistanceChunkData, forKey: "assistanceChunks")
//        print(assistanceChunks)
//
//        collectionView.reloadSections(IndexSet(integer: 0))
//
//    }
//
//    //MARK: Segue methods
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showWeek" {
//            print("Show week segue called")
//            let vc = segue.destination as! WeekVC
//            vc.liftsToPass = cachedLifts
//            vc.percentagesToPass = weekPercentages[selectedIndex!]
//            vc.navigationItem.title = weekTitles[selectedIndex!]
//            vc.repsToPass = weekReps[selectedIndex!]
//            vc.roundTo = UserDefaults.standard.value(forKey: "roundTo") as? Double
//            vc.checkboxStates = checkboxStates[selectedIndex!]
//            vc.assistanceForEachDay = assistanceForEachDay
//            vc.assistanceChunks = assistanceChunks
//            vc.delegate = self
//        }
//    }
}
