//
//  Common.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation

let IS_TESTING = { (isTesting: String?) -> Bool in
    if case let .some(value) = isTesting, value == "true" {
        return true
    }
    return false
}(ProcessInfo().environment["IS_TESTING"])
