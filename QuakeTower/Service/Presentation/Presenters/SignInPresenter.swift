//
//  SignInPresenter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

protocol SignInPresentation: Presentation
where ViewController: SignInUserInterface, Interactor: SignInUsecase, Router: SignInWireframe {
}

class SignInPresenter<T: SignInUserInterface, U: SignInUsecase, V: SignInWireframe>: SignInPresentation {

    typealias ViewController = T
    typealias Interactor = U
    typealias Router = V

    weak var vc: ViewController?
    let interactor: Interactor
    let router: Router

    required init(vc: ViewController, interactor: Interactor, router: Router) {
        self.vc = vc
        self.interactor = interactor
        self.router = router
    }
}
