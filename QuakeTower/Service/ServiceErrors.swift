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
        case idsDoNotExist
    }

    enum Server: Error {
        enum Ver1: Int, Error {
            case appNeedsToBeUpdated = 1_001
            case signInFailure = 1_002
            case idsMismatch = 1_003
            case notEnoughGold = 1_004
            case towerIsCollapsed = 1_005
        }
    }

    case client(_ error: Client)
    case server(_ error: Server)
    case myError(_ error: MyError)
}
