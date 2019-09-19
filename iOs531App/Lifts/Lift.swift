//
//  Lift.swift
//  iOs531App
//
//  Created by Kevin Li on 9/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class Lift: NSObject, NSCoding {
    
    enum Keys : String{
        case name = "Name"
        case progression = "Progression"
        case trainingMax = "Training Max"
        case personalRecord = "Personal Record"
        case day = "Day"
    }

    var name: String
    var progression: Double
    var trainingMax: Double
    var personalRecord : Int
    var day : Int
    
    init(name: String, progression: Double, trainingMax: Double, personalRecord : Int, day : Int) {
        self.name = name
        self.progression = progression
        self.trainingMax = trainingMax
        self.personalRecord = personalRecord
        self.day = day
    }
    
    //MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String
            else {
                return nil
        }
        
        self.init(
            name: name,
            progression: aDecoder.decodeDouble(forKey: Keys.progression.rawValue),
            trainingMax: aDecoder.decodeDouble(forKey: Keys.trainingMax.rawValue),
            personalRecord: aDecoder.decodeInteger(forKey: Keys.personalRecord.rawValue),
            day: aDecoder.decodeInteger(forKey: Keys.day.rawValue)
            )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: Keys.name.rawValue)
        aCoder.encode(self.progression, forKey: Keys.progression.rawValue)
        aCoder.encode(self.trainingMax, forKey: Keys.trainingMax.rawValue)
        aCoder.encode(self.personalRecord, forKey: Keys.personalRecord.rawValue)
        aCoder.encode(self.day, forKey: Keys.day.rawValue)
    }
}
