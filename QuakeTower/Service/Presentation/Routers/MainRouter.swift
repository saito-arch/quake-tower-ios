//
//  MainRouter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/27.
//

import UIKit

protocol MainWireframe: Wireframe where ViewController: MainUserInterface {
    func signOut()
}

struct MainRouter {
    typealias ViewController = MainViewController

    weak var vc: ViewController?

    init(vc: ViewController) {
        self.vc = vc
    }

    // MARK: - factory
    static func instantiate() -> ViewController {
        guard let vc = R.storyboard.main.instantiateInitialViewController() else {
            fatalError("ViewController doesn't exist")
        }

        let interactor = MainInteractor()
        let router = MainRouter(vc: vc)
        let presenter = MainPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)

        return vc
    }
}

extension MainRouter: MainWireframe {
    func signOut() {
        Session.shared.currentAccount.clear()
        toSignInVc()
    }
}
