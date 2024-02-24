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

func log(_ msg: String, file: String = #file, line: Int = #line, function: String = #function) {

    var f = "NONE"

    if let _f = file.components(separatedBy: "/").last {
        f = _f.replacingOccurrences(of: ".swift", with: "")
        f = f.replacingOccurrences(of: "ViewController", with: "Vc")
        f = f.replacingOccurrences(of: "Repository", with: "Rp")
        f = f.replacingOccurrences(of: "Interactor", with: "Ir")
        f = f.replacingOccurrences(of: "Presenter", with: "Ps")
    }

    print("\(f):\(line) [\(function)]: \(msg)")
}
