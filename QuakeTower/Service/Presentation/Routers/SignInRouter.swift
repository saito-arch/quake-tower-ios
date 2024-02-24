//
//  SignInRouter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit

protocol SignInWireframe: Wireframe where ViewController: SignInUserInterface {
}

struct SignInRouter {
    typealias ViewController = SignInViewController

    weak var vc: ViewController?

    init(vc: ViewController) {
        self.vc = vc
    }

    // MARK: - factory
    static func instantiate() -> ViewController {
        guard let vc = R.storyboard.signIn.instantiateInitialViewController() else {
            fatalError("ViewController doesn't exist")
        }

        let interactor = SignInInteractor()
        let router = SignInRouter(vc: vc)
        let presenter = SignInPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)

        return vc
    }
}

extension SignInRouter: SignInWireframe {
}

