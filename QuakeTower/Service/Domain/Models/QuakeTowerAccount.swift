//
//  QuakeTowerAccount.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

class QuakeTowerAccount {
    var playerId: Int64? {
        get {
            if let playerId = Stored.Int64Value.playerId.object() {
                return playerId
            } else {
                return nil
            }
        }
        set {
            if let playerId = newValue {
                Stored.Int64Value.playerId.set(playerId)
            } else {
                Stored.Int64Value.playerId.removeObject()
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

    func clear() {
        self.playerId = nil
        self.playerName = nil
    }

    init() {}

    func fetchPlayerInfo(with uuid: String, playerId: Int64)
    -> Single<ApiContext<PlayerInfo, MyError>> {
        ApiService.shared.fetchPlayerInfo(with: uuid, playerId: playerId)
    }
}
