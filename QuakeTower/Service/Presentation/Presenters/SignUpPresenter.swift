//
//  SignUpPresenter.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import RxSwift

protocol SignUpPresentation: Presentation
where ViewController: SignUpUserInterface, Interactor: SignUpUsecase, Router: SignUpWireframe {
}

class SignUpPresenter<T: SignUpUserInterface, U: SignUpUsecase, V: SignUpWireframe>: SignUpPresentation {

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
