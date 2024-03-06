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
