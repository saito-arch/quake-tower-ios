//
//  MainSpec.swift
//  QuakeTowerTests
//
//  Created by Saito on 2024/03/06.
//

import Foundation
import Quick
import Nimble
@testable import QuakeTower

class MainViewControllerMock: MainUserInterface {

    typealias Presenter = MainPresenter<MainViewControllerMock, MainInteractor, MainRouterMock>
    var presenter: Presenter?

    func set(presenter: Presenter) {
        self.presenter = presenter
    }

    private var embeddedClosure4AlertV2: ((AlertActionPatternV2) -> Void)?
    func embedAssertion4AlertV2(closure: @escaping ((AlertActionPatternV2) -> Void)) {
        self.embeddedClosure4AlertV2 = closure
    }
    func showAlert(
        title: String?,
        message: String,
        pattern: AlertActionPatternV2,
        handler: ((UIAlertAction) -> Void)?
    ) {
        self.embeddedClosure4AlertV2?(pattern)
        self.embeddedClosure4AlertV2 = nil
    }

    private var embeddedClosure4Alert: ((MessagePatternId) -> Void)?
    func embedAssertion4Alert(closure: @escaping ((MessagePatternId) -> Void)) {
        self.embeddedClosure4Alert = closure
    }
    func showAlert(of pattern: MessagePatternId, handler: ((UIAlertAction) -> Void)?) {
        self.embeddedClosure4Alert?(pattern)
        self.embeddedClosure4Alert = nil
    }

    private var embeddedClosure4UpdateGoldAndAnnotations: ((Int, [TowerAnnotation], [BuildTowerAnnotation]) -> Void)?
    func embedAssertion4UpdateGoldAndAnnotations(
        closure: @escaping ((Int, [TowerAnnotation], [BuildTowerAnnotation]) -> Void)
    ) {
        self.embeddedClosure4UpdateGoldAndAnnotations = closure
    }
    func updateGoldAndAnnotations(
        gold: Int,
        towerAnnotations: [TowerAnnotation],
        buildTowerAnnotations: [BuildTowerAnnotation]
    ) {
        self.embeddedClosure4UpdateGoldAndAnnotations?(
            gold,
            towerAnnotations,
            buildTowerAnnotations
        )
        self.embeddedClosure4UpdateGoldAndAnnotations = nil
    }

    // Don't use protocol method in spec
    func showIndicator() {}
    func hideIndicator() {}
}

class MainRouterMock: MainWireframe {

    typealias ViewController = MainViewControllerMock

    var vc: ViewController?

    init(vc: ViewController) { self.vc = vc }

    // MARK: factory
    static func instantiate() -> ViewController {
        let vc = MainViewControllerMock()
        let interactor = MainInteractor()
        let router = MainRouterMock(vc: vc)
        let presenter = MainPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)
        return vc
    }

    func signOut() {}
    func assertErrorContext(error: Error) {}
}

// MARK: - TestCases
class MainSpec: QuickSpec {
    override func spec() {

        let vc = MainRouterMock.instantiate()
        let presenter = vc.presenter!

        let uuid = "uuid"
        let playerId: Int64 = 0
        let gold = 100
        let goldHour = 1
        let tower = Tower(id: 0, prefectureId: 1, latitude: 35.0, longitude: 139.0, hp: 3, maxHp: 3, height: 1, goldHour: 1)
        let towers = [tower]
        let gameInfo = GameInfo(goldBuildBase: 100, goldExtendBase: 100, goldReinforceBase: 100, goldRepairBase: 100)


        /* Scenario 1: fetch player info
         * Presenter method : fetchPlayerInfo
         * API              : Apis.Ver1.FetchPlayerInfo
         */
        describe("fetch player info") {
            context("uuid is nil") {
                beforeEach {
                    Session.shared.uuid = nil
                }
                it("show alert 003") {
                    waitUntil(timeout: TIMEOUT) { done in
                        let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                            stub: Apis.Ver1.FetchPlayerInfo.Response(
                                gold: gold,
                                goldHour: goldHour,
                                towers: towers,
                                gameInfo: gameInfo
                            )
                        )
                        ApiService.set(apiClient: mock)
                        vc.embedAssertion4Alert { pattern in
                            expect({
                                guard case .d003 = pattern else {
                                    return .failed(reason: "wrong enum case: \(pattern)")
                                }
                                print(">>> success \(pattern)")
                                return .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.fetchPlayerInfo()
                    }
                }
            }
            context("uuid is NOT nil") {
                beforeEach {
                    Session.shared.uuid = uuid
                }
                context("playerId is nil") {
                    beforeEach {
                        Session.shared.currentAccount.playerId = nil
                    }
                    it("show alert 003") {
                        waitUntil(timeout: TIMEOUT) { done in
                            let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                stub: Apis.Ver1.FetchPlayerInfo.Response(
                                    gold: gold,
                                    goldHour: goldHour,
                                    towers: towers,
                                    gameInfo: gameInfo
                                )
                            )
                            ApiService.set(apiClient: mock)
                            vc.embedAssertion4Alert { pattern in
                                expect({
                                    guard case .d003 = pattern else {
                                        return .failed(reason: "wrong enum case: \(pattern)")
                                    }
                                    print(">>> success \(pattern)")
                                    return .succeeded
                                }).to(succeed())
                                done()
                            }
                            presenter.fetchPlayerInfo()
                        }
                    }
                }
                context("playerId is NOT nil") {
                    beforeEach {
                        Session.shared.currentAccount.playerId = playerId
                    }
                    context("when network error") {
                        it("show alert 001") {
                            waitUntil(timeout: TIMEOUT) { done in
                                var mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                    stub: Apis.Ver1.FetchPlayerInfo.Response(
                                        gold: gold,
                                        goldHour: goldHour,
                                        towers: towers,
                                        gameInfo: gameInfo
                                    )
                                )
                                mock.isReachable = false
                                ApiService.set(apiClient: mock)
                                vc.embedAssertion4Alert { pattern in
                                    expect({
                                        guard case .d001 = pattern else {
                                            return .failed(reason: "wrong enum case: \(pattern)")
                                        }
                                        print(">>> success \(pattern)")
                                        return .succeeded
                                    }).to(succeed())
                                    done()
                                }
                                presenter.fetchPlayerInfo()
                            }
                        }
                    }
                    context("when 2xxx error") {
                        it("show alert 2xxx") {
                            waitUntil(timeout: TIMEOUT) { done in
                                let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                    error: MyError(
                                        code: 2_000,
                                        message: "testErrorMessage",
                                        errorTitle: "testErrorTitle",
                                        retryable: false
                                    )
                                )
                                ApiService.set(apiClient: mock)
                                vc.embedAssertion4AlertV2 { pattern in
                                    expect({
                                        guard case .d2xxx = pattern else {
                                            return .failed(reason: "wrong enum case: \(pattern)")
                                        }
                                        print(">>> success \(pattern)")
                                        return .succeeded
                                    }).to(succeed())
                                    done()
                                }
                                presenter.fetchPlayerInfo()
                            }
                        }
                    }
                    context("ids mismatch") {
                        it("show alert 003") {
                            waitUntil(timeout: TIMEOUT) { done in
                                let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                    error: MyError(
                                        code: 1_003,
                                        message: "testErrorMessage",
                                        errorTitle: "testErrorTitle",
                                        retryable: false
                                    )
                                )
                                ApiService.set(apiClient: mock)
                                vc.embedAssertion4Alert { pattern in
                                    expect({
                                        guard case .d003 = pattern else {
                                            return .failed(reason: "wrong enum case: \(pattern)")
                                        }
                                        print(">>> success \(pattern)")
                                        return .succeeded
                                    }).to(succeed())
                                    done()
                                }
                                presenter.fetchPlayerInfo()
                            }
                        }
                    }
                    context("unexpected error") {
                        it("show alert 000") {
                            waitUntil(timeout: TIMEOUT) { done in
                                let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                    error: MyError(
                                        code: 1_999,
                                        message: "testErrorMessage",
                                        errorTitle: "testErrorTitle",
                                        retryable: false
                                    )
                                )
                                ApiService.set(apiClient: mock)
                                vc.embedAssertion4Alert { pattern in
                                    expect({
                                        guard case .d000 = pattern else {
                                            return .failed(reason: "wrong enum case: \(pattern)")
                                        }
                                        print(">>> success \(pattern)")
                                        return .succeeded
                                    }).to(succeed())
                                    done()
                                }
                                presenter.fetchPlayerInfo()
                            }
                        }
                    }
                    context("fetch player info success") {
                        it("update gold and annotations") {
                            waitUntil(timeout: TIMEOUT) { done in
                                let mock = MockApiClient<Apis.Ver1.FetchPlayerInfo>(
                                    stub: Apis.Ver1.FetchPlayerInfo.Response(
                                        gold: gold,
                                        goldHour: goldHour,
                                        towers: towers,
                                        gameInfo: gameInfo
                                    )
                                )
                                ApiService.set(apiClient: mock)
                                vc.embedAssertion4UpdateGoldAndAnnotations {
                                    gold, towerAnnotations, buildTowerAnnotations in
                                    expect({
                                        guard case 100 = gold else {
                                            return .failed(reason: "wrong enum case: \(gold)")
                                        }
                                        guard case 1 = towerAnnotations.count else {
                                            return .failed(reason: "wrong enum case: \(gold)")
                                        }
                                        guard case 47 = buildTowerAnnotations.count else {
                                            return .failed(reason: "wrong enum case: \(gold)")
                                        }
                                        print(">>> success \(gold) \(towerAnnotations) \(buildTowerAnnotations)")
                                        return .succeeded
                                    }).to(succeed())
                                    done()
                                }
                                presenter.fetchPlayerInfo()
                            }
                        }
                    }
                }
            }
        }
    }
}
