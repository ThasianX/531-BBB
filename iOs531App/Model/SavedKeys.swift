//
//  SavedKeys.swift
//  iOs531App
//
//  Created by Kevin Li on 10/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SavedKeys {
    private (set) static var finishedSetup = "finishedSetup"
    private (set) static var roundTo = "roundTo"
    private (set) static var checkboxStates = "checkboxStates"
    
    static func getTimerSwitchKeys(timer: Int) -> String {
        return "timerSwitch\(timer)"
    }
    
    static func getTimeLeftKeys(timer: Int) -> String {
        return "timeLeft\(timer)"
    }
}
