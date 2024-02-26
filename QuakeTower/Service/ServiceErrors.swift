//
//  ServiceErrors.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation

enum ServiceErrors: Error {

    enum Client: Error {
        case disconnection
    }

    enum Server: Error {
        enum Ver1: Int, Error {
            case appNeedsToBeUpdated = 1_001
            case signInFailure = 1_002
            case alwaysRegistered = 1_003
        }
    }

    case client(_ error: Client)
    case server(_ error: Server)
    case myError(_ error: MyError)
}
