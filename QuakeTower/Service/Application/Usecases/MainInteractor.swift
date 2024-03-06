//
//  MainInteractor.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import Foundation
import RxSwift

enum FetchPlayerInfo: Scenario {
    case idsRegistered(uuid: String, playerId: Int64)
    case fetchPlayerInfoSuccess(playerInfo: PlayerInfo)
    case idsMismatch
    case unexpectedError

    init?() {
        if let uuid = Session.shared.uuid,
            let playerId = Session.shared.currentAccount.playerId {
            log("uuid: \(uuid), playerId: \(playerId)")
            self = .idsRegistered(uuid: uuid, playerId: playerId)
        } else {
            log("ids doesn't exist")
            return nil
        }
    }

    func fetchPlayerInfo(with uuid: String, playerId: Int64) -> Single<FetchPlayerInfo> {
        Session.shared.currentAccount.fetchPlayerInfo(with: uuid, playerId: playerId)
            .map { apiContext -> FetchPlayerInfo in
                switch apiContext {
                case .success(let playerInfo):
                    return .fetchPlayerInfoSuccess(playerInfo: playerInfo)
                case .failure(let myError):
                    switch myError.code {
                    case ServiceErrors.Server.Ver1.idsMismatch.rawValue:
                        return .idsMismatch
                    default:
                        return .unexpectedError
                    }
                }
            }
    }

    func next() -> Single<FetchPlayerInfo>? {
        switch self {
        case .idsRegistered(let uuid, let playerId):
            return self.fetchPlayerInfo(with: uuid, playerId: playerId)

        case .fetchPlayerInfoSuccess,
            .idsMismatch,
            .unexpectedError:
            return nil
        }
    }
}

enum ExecuteCommand: Scenario {
    case idsRegistered(uuid: String, playerId: Int64, towerId: Int64, number: Int, tower: Tower?)
    case commandSuccess(playerInfo: PlayerInfo)
    case idsMismatch
    case notEnoughGold
    case towerIsCollapsed
    case unexpectedError

    init?(towerId: Int64, number: Int, tower: Tower?) {
        if let uuid = Session.shared.uuid,
            let playerId = Session.shared.currentAccount.playerId {
            log("uuid: \(uuid), playerId: \(playerId)")
            self = .idsRegistered(uuid: uuid, playerId: playerId, towerId: towerId, number: number, tower: tower)
        } else {
            log("ids doesn't exist")
            return nil
        }
    }

    func command(
        with uuid: String,
        playerId: Int64,
        towerId: Int64,
        number: Int,
        tower: Tower?
    ) -> Single<ExecuteCommand> {
        Session.shared.currentAccount.command(with: uuid, playerId: playerId, towerId: towerId, number: number, tower: tower)
            .map { apiContext -> ExecuteCommand in
                switch apiContext {
                case .success(let playerInfo):
                    return .commandSuccess(playerInfo: playerInfo)
                case .failure(let myError):
                    switch myError.code {
                    case ServiceErrors.Server.Ver1.idsMismatch.rawValue:
                        return .idsMismatch
                    case ServiceErrors.Server.Ver1.notEnoughGold.rawValue:
                        return .notEnoughGold
                    case ServiceErrors.Server.Ver1.towerIsCollapsed.rawValue:
                        return .towerIsCollapsed
                    default:
                        return .unexpectedError
                    }
                }
            }
    }

    func next() -> Single<ExecuteCommand>? {
        switch self {
        case .idsRegistered(let uuid, let playerId, let towerId, let number, let tower):
            return self.command(with: uuid, playerId: playerId, towerId: towerId, number: number, tower: tower)

        case .commandSuccess,
            .idsMismatch,
            .notEnoughGold,
            .towerIsCollapsed,
            .unexpectedError:
            return nil
        }
    }
}

protocol MainUsecase: Usecase {
    /// usecase "FetchPlayerInfo"
    ///
    /// - Parameters:
    /// - Returns: Context of execution result
    func fetchPlayerInfo() -> Single<[FetchPlayerInfo]>
    /// usecase "Command"
    ///
    /// - Parameters:
    ///   - towerId: tower's ID
    ///   - number: command's number
    ///   - tower: (build only) building tower   
    /// - Returns: Context of execution result
    func command(towerId: Int64, number: Int, tower: Tower?) -> Single<[ExecuteCommand]>
}

struct MainInteractor: MainUsecase {
    func fetchPlayerInfo() -> Single<[FetchPlayerInfo]> {
        if let context = FetchPlayerInfo() {
            return self.interact(contexts: [context])
        } else {
            return Single<[FetchPlayerInfo]>.error(ServiceErrors.client(.idsDoNotExist))
        }
    }

    func command(towerId: Int64, number: Int, tower: Tower?) -> Single<[ExecuteCommand]> {
        if let context = ExecuteCommand(towerId: towerId, number: number, tower: tower) {
            return self.interact(contexts: [context])
        } else {
            return Single<[ExecuteCommand]>.error(ServiceErrors.client(.idsDoNotExist))
        }
    }
}
