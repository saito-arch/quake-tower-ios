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

    var goldBuildBase: Int? {
        get {
            if let goldBuildBase = Stored.IntValue.goldBuildBase.object() {
                return goldBuildBase
            } else {
                return nil
            }
        }
        set {
            if let goldBuildBase = newValue {
                Stored.IntValue.goldBuildBase.set(goldBuildBase)
            } else {
                Stored.IntValue.goldBuildBase.removeObject()
            }
        }
    }

    var goldExtendBase: Int? {
        get {
            if let goldExtendBase = Stored.IntValue.goldExtendBase.object() {
                return goldExtendBase
            } else {
                return nil
            }
        }
        set {
            if let goldExtendBase = newValue {
                Stored.IntValue.goldExtendBase.set(goldExtendBase)
            } else {
                Stored.IntValue.goldExtendBase.removeObject()
            }
        }
    }

    var goldReinforceBase: Int? {
        get {
            if let goldReinforceBase = Stored.IntValue.goldReinforceBase.object() {
                return goldReinforceBase
            } else {
                return nil
            }
        }
        set {
            if let goldReinforceBase = newValue {
                Stored.IntValue.goldReinforceBase.set(goldReinforceBase)
            } else {
                Stored.IntValue.goldReinforceBase.removeObject()
            }
        }
    }

    var goldRepairBase: Int? {
        get {
            if let goldRepairBase = Stored.IntValue.goldRepairBase.object() {
                return goldRepairBase
            } else {
                return nil
            }
        }
        set {
            if let goldRepairBase = newValue {
                Stored.IntValue.goldRepairBase.set(goldRepairBase)
            } else {
                Stored.IntValue.goldRepairBase.removeObject()
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
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let playerInfo):
                    let gameInfo = playerInfo.gameInfo
                    self.goldBuildBase = gameInfo.goldBuildBase
                    self.goldExtendBase = gameInfo.goldExtendBase
                    self.goldReinforceBase = gameInfo.goldReinforceBase
                    self.goldRepairBase = gameInfo.goldRepairBase

                default:
                    break
                }
            })
    }

    func command(with uuid: String, playerId: Int64, towerId: Int64, number: Int, tower: Tower?)
    -> Single<ApiContext<PlayerInfo, MyError>> {
        ApiService.shared.command(with: uuid, playerId: playerId, towerId: towerId, number: number, tower: tower)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let playerInfo):
                    let gameInfo = playerInfo.gameInfo
                    self.goldBuildBase = gameInfo.goldBuildBase
                    self.goldExtendBase = gameInfo.goldExtendBase
                    self.goldReinforceBase = gameInfo.goldReinforceBase
                    self.goldRepairBase = gameInfo.goldRepairBase

                default:
                    break
                }
            })
    }
}
