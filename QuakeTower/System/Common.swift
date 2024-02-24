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

func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {

    var file = "NONE"

    if let fileLast = file.components(separatedBy: "/").last {
        file = fileLast.replacingOccurrences(of: ".swift", with: "")
        file = file.replacingOccurrences(of: "ViewController", with: "Vc")
        file = file.replacingOccurrences(of: "Repository", with: "Rp")
        file = file.replacingOccurrences(of: "Interactor", with: "Ir")
        file = file.replacingOccurrences(of: "Presenter", with: "Ps")
    }

    print("\(file):\(line) [\(function)]: \(message)")
}
