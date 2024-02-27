//
//  QuakeTowerAccount.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

class QuakeTowerAccount {
    var playerId: Int? {
        get {
            if let playerId = Stored.IntValue.playerId.object() {
                return playerId
            } else {
                return nil
            }
        }
        set {
            if let playerId = newValue {
                Stored.IntValue.playerId.set(playerId)
            } else {
                Stored.IntValue.playerId.removeObject()
            }
        }
    }

    var playerName: String? {
        get {
            if let playerName = Stored.StringValue.playerName.object() {
                return playerName
            } else {
                return nil
            }
        }
        set {
            if let playerName = newValue {
                Stored.StringValue.playerName.set(playerName)
            } else {
                Stored.StringValue.playerName.removeObject()
            }
        }
    }

    init() {}
}
