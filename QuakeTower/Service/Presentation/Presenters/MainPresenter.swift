//
//  MainPresenter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import Foundation
import RxSwift

protocol MainPresentation: Presentation
where ViewController: MainUserInterface, Interactor: MainUsecase, Router: MainWireframe {
    func fetchPlayerInfo()
    func onTouchBuildButton(prefecture: Prefecture)
    func onTouchExtendButton(tower: Tower)
    func onTouchReinforceButton(tower: Tower)
    func onTouchRepairButton(tower: Tower)
}

class MainPresenter<T: MainUserInterface, U: MainUsecase, V: MainWireframe>: MainPresentation {

    typealias ViewController = T
    typealias Interactor = U
    typealias Router = V

    weak var vc: ViewController?
    let interactor: Interactor
    let router: Router

    var playerInfo: PlayerInfo?

    required init(vc: ViewController, interactor: Interactor, router: Router) {
        self.vc = vc
        self.interactor = interactor
        self.router = router
    }

    func onTouchBuildButton(prefecture: Prefecture) {
        let command = Command.build
        if let cost = command.calculateGold(height: 0) {
            self.vc?.showAlert(
                title: TITLE_COMMAND,
                message: command.getAlertMessage(gold: cost, prefectureName: "\(prefecture)"),
                pattern: .command
            ) { [weak self] action in
                switch action.title {
                case COMMON_OK:
                    if let towers = self?.playerInfo?.towers {
                        let tower = self?.generateTower(prefecture: prefecture, buildedTowers: towers)
                        self?.command(towerId: 0, number: command.rawValue, tower: tower)
                    }
                default:
                    break
                }
            }
        }
    }

    private func generateTower(prefecture: Prefecture, buildedTowers: [Tower]) -> TowerForBuild {
        let towers = buildedTowers.filter { $0.prefectureId == prefecture.rawValue }
        var latLng = prefecture.getRandomLatLng()
        while isConflict(latLng: latLng, towers: towers) {
            latLng = prefecture.getRandomLatLng()
        }

        return TowerForBuild(
            prefectureId: prefecture.rawValue,
            latitude: latLng.latitude,
            longitude: latLng.longitude
        )
    }

    private func isConflict(latLng: LatLng, towers: [Tower]) -> Bool {
        for tower in towers where isNearby(latLng, LatLng(latitude: tower.latitude, longitude: tower.longitude)) {
            return true
        }

        return false
    }

    private func isNearby(_ latLng1: LatLng, _ latLng2: LatLng) -> Bool {
        if isNearby(latLng1.latitude, latLng2.latitude) && isNearby(latLng1.longitude, latLng2.longitude) {
            return true
        }

        return false
    }

    private func isNearby(_ double1: Double, _ double2: Double) -> Bool {
        let diff = double1 - double2
        if diff >= -0.001 && diff <= 0.001 {
            return true
        }

        return false
    }

    func onTouchExtendButton(tower: Tower) {
        onTouchCommandButtonExceptBuild(command: Command.extend, tower: tower)
    }

    func onTouchReinforceButton(tower: Tower) {
        onTouchCommandButtonExceptBuild(command: Command.reinforce, tower: tower)
    }

    func onTouchRepairButton(tower: Tower) {
        onTouchCommandButtonExceptBuild(command: Command.repair, tower: tower)
    }

    private func onTouchCommandButtonExceptBuild(command: Command, tower: Tower) {
        if let cost = command.calculateGold(height: tower.height) {
            self.vc?.showAlert(
                title: TITLE_COMMAND,
                message: command.getAlertMessage(gold: cost, prefectureName: ""),
                pattern: .command
            ) { [weak self] action in
                switch action.title {
                case COMMON_OK:
                    self?.command(towerId: tower.id, number: command.rawValue)
                default:
                    break
                }
            }
        }
    }

    func fetchPlayerInfo() {
        vc?.showIndicator()
        _ = self.interactor.fetchPlayerInfo()
            .do(onSuccess: { _ in
                self.vc?.hideIndicator()
            }, onError: { _ in
                self.vc?.hideIndicator()
            })
            .subscribe(onSuccess: { contexts in
                self.onSuccessFetchPlayerInfo(contexts: contexts)
            }, onFailure: { error in
                self.onFailureFetchPlayerInfo(error: error)
            })
    }

    private func onSuccessFetchPlayerInfo(contexts: [FetchPlayerInfo]) {
        log(">>> contexts \(contexts)")
        let context = contexts.last
        switch context {
        case .some(.fetchPlayerInfoSuccess(let playerInfo)):
            self.playerInfo = playerInfo
            self.vc?.updateGoldAndAnnotations(
                gold: playerInfo.gold,
                towerAnnotations: makeTowerAnnotations(towers: playerInfo.towers),
                buildTowerAnnotations: makeBuildTowerAnnotations(isEnabled: playerInfo.towers.count < 100)
            )
        case .some(.idsMismatch):
            self.vc?.showAlert(of: .d003) { [weak self] _ in
                self?.router.signOut()
            }
        case .some(.unexpectedError):
            self.vc?.showAlert(of: .d000, handler: nil)
        default:
            fatalError("\(contexts.last.debugDescription)")
        }
    }

    private func onFailureFetchPlayerInfo(error: Error) {
        switch error {
        case ServiceErrors.client(let clientError):
            log("Unexpected error during usecase execution: \(String(describing: clientError))")
            switch clientError {
            case .idsDoNotExist:
                self.vc?.showAlert(of: .d003) { [weak self] _ in
                    self?.router.signOut()
                }
            default:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* Service Errors each API */
        case ErrorWrapper<Apis.Ver1.FetchPlayerInfo>.service(let serviceError, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            switch serviceError {
            case .myError(let error):
                self.vc?.showAlert(title: error.errorTitle, message: error.message, pattern: .d2xxx, handler: nil)
            case .client(.disconnection):
                self.vc?.showAlert(of: .d001, handler: nil)
            default:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* System Errors each API */
        case ErrorWrapper<Apis.Ver1.FetchPlayerInfo>.system(_, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(error)")
        }
    }

    func command(towerId: Int64, number: Int, tower: TowerForBuild? = nil) {
        vc?.showIndicator()
        _ = self.interactor.command(towerId: towerId, number: number, tower: tower)
            .do(onSuccess: { _ in
                self.vc?.hideIndicator()
            }, onError: { _ in
                self.vc?.hideIndicator()
            })
            .subscribe(onSuccess: { contexts in
                self.onSuccessCommand(contexts: contexts)
            }, onFailure: { error in
                self.onFailureCommand(error: error)
            })
    }

    private func onSuccessCommand(contexts: [ExecuteCommand]) {
        log(">>> contexts \(contexts)")
        let context = contexts.last
        switch context {
        case .some(.commandSuccess(let playerInfo)):
            self.playerInfo = playerInfo
            self.vc?.updateGoldAndAnnotations(
                gold: playerInfo.gold,
                towerAnnotations: makeTowerAnnotations(towers: playerInfo.towers),
                buildTowerAnnotations: makeBuildTowerAnnotations(isEnabled: playerInfo.towers.count < 100)
            )
        case .some(.idsMismatch):
            self.vc?.showAlert(of: .d003) { [weak self] _ in
                self?.router.signOut()
            }
        case .some(.notEnoughGold):
            self.vc?.showAlert(of: .d004) { [weak self] _ in
                self?.fetchPlayerInfo()
            }
        case .some(.towerIsCollapsed):
            self.vc?.showAlert(of: .d005) { [weak self] _ in
                self?.fetchPlayerInfo()
            }
        case .some(.unexpectedError):
            self.vc?.showAlert(of: .d000, handler: nil)
        default:
            fatalError("\(contexts.last.debugDescription)")
        }
    }

    private func onFailureCommand(error: Error) {
        switch error {
        case ServiceErrors.client(let clientError):
            log("Unexpected error during usecase execution: \(String(describing: clientError))")
            switch clientError {
            case .idsDoNotExist:
                self.vc?.showAlert(of: .d003) { [weak self] _ in
                    self?.router.signOut()
                }
            default:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* Service Errors each API */
        case ErrorWrapper<Apis.Ver1.Command>.service(let serviceError, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            switch serviceError {
            case .myError(let error):
                self.vc?.showAlert(title: error.errorTitle, message: error.message, pattern: .d2xxx, handler: nil)
            case .client(.disconnection):
                self.vc?.showAlert(of: .d001, handler: nil)
            default:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* System Errors each API */
        case ErrorWrapper<Apis.Ver1.Command>.system(_, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(error)")
        }
    }

    private func makeTowerAnnotations(towers: [Tower]) -> [TowerAnnotation] {
        var annotations: [TowerAnnotation] = []
        for tower in towers {
            annotations.append(TowerAnnotation(tower: tower))
        }

        return annotations
    }

    private func makeBuildTowerAnnotations(isEnabled: Bool) -> [BuildTowerAnnotation] {
        var annotations: [BuildTowerAnnotation] = []
        for prefecture in Prefecture.allCases {
            annotations.append(BuildTowerAnnotation(prefecture: prefecture, isEnabled: isEnabled))
        }

        return annotations
    }
}
