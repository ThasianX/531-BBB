//
//  SetViewModel.swift
//  iOs531App
//
//  Created by Kevin Li on 10/12/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

protocol SetViewModel {
    func getLabel() -> String
    func getDescription() -> String
    func checked() -> Bool
    func setChecked(checked: Bool)
}
