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
        return weekTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekDisplayCell", for: indexPath) as! WeekDisplayCell
        cell.weekLabel.text = weekTitles[indexPath.row]
        cell.trainingPercentagesLabel.text = weekDescriptions[indexPath.row]
        let numberOfTrue = checkboxStates[indexPath.row].filter{$0}.count
        print("There are \(numberOfTrue) trues out in the array of  \(checkboxStates[indexPath.row]) booleans")
        let progress = Float(numberOfTrue / checkboxStates[indexPath.row].count)
        cell.progressView.setProgress(progress, animated: true)
        cell.progressViewLabel.text = "\(Int(progress))% complete"
        
        return cell
    }
}

extension CycleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedIndex = indexPath.row
        return true
    }
}

extension CycleVC: WeekVCDelegate {
    func setClicked(index: Int) {
        
    }
}


class CycleVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Data
    let weekTitles = ["Week 1", "Week 2", "Week 3", "Week 4"]
    let weekDescriptions = ["5/3/1 - 65% | 75% | 85%", "5/3/1 - 70% | 80% | 90%", "5/3/1 - 75% | 85% | 95%", "Deload - 40% | 50% | 60%"]
    let weekReps = [[5,5,5],[3,3,3], [5,3,1],[5,5,5]]
    var checkboxStates : [[Bool]] = [[]]
    var cachedLifts: [Lift] = []
    let weekPercentages = [[0.65,0.75,0.85], [0.70,0.80,0.90], [0.75,0.85,0.95], [0.40,0.50,0.60]]
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        checkboxStates = defaults.value(forKey: "checkboxStates") as! [[Bool]]
        
        if defaults.value(forKey: "notFirstCycle") != nil{
            print("Setting cached lifts1")
            if let savedData = defaults.value(forKey: "cachedLifts") as? Data {
                if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
                    print("Setting cached lifts2")
                    cachedLifts = decodedData
                }
            }
        } else {
            defaults.set(true, forKey: "notFirstCycle")
            print("Setting cached lifts3")
            
            if let savedData = defaults.value(forKey: "lifts") as? Data {
                if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Lift] {
                    print("Setting cached lifts4")
                    cachedLifts = decodedData
                }
            }
            
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cachedLifts, requiringSecureCoding: false){
                defaults.set(savedData, forKey: "cachedLifts")
            }
        }
    }
    
    //MARK: Bar Button Action
    @IBAction func resetCycle(_ sender: UIBarButtonItem) {
        //Recalculate the number of checkboxes there are.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeek" {
            print("Show week segue called")
            let vc = segue.destination as! WeekVC
            vc.liftsToPass = cachedLifts
            vc.percentagesToPass = weekPercentages[selectedIndex!]
            vc.navigationItem.title = weekTitles[selectedIndex!]
            vc.repsToPass = weekReps[selectedIndex!]
            vc.roundTo = UserDefaults.standard.value(forKey: "roundTo") as? Double
            vc.delegate = self
        }
    }
}
