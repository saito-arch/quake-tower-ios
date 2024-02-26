//
//  SignUpRouter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/26.
//

import UIKit

protocol SignUpWireframe: Wireframe where ViewController: SignUpUserInterface {
    func toMain()
}

struct SignUpRouter {
    typealias ViewController = SignUpViewController

    weak var vc: ViewController?

    init(vc: ViewController) {
        self.vc = vc
    }

    // MARK: - factory
    static func instantiate() -> ViewController {
        guard let vc = R.storyboard.signUp.instantiateInitialViewController() else {
            fatalError("ViewController doesn't exist")
        }

        let interactor = SignUpInteractor()
        let router = SignUpRouter(vc: vc)
        let presenter = SignUpPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)

        return vc
    }
}

extension SignUpRouter: SignUpWireframe {
    func toMain() {
        // TODO: to main screen
    }
}
