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
}

class MainPresenter<T: MainUserInterface, U: MainUsecase, V: MainWireframe>: MainPresentation {

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
