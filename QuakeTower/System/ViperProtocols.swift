//
//  ViperProtocols.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit

// MARK: - View
protocol UserInterface: AnyObject {
    associatedtype Presenter: Presentation
    var presenter: Presenter? { get set }

    func set(presenter: Presenter)
}

extension UserInterface {
    func set(presenter: Presenter) {
        self.presenter = presenter
    }
}

// MARK: - Interactor
protocol Usecase { }

// MARK: - Presenter
protocol Presentation: AnyObject {
    associatedtype ViewController: UserInterface
    associatedtype Interactor: Usecase
    associatedtype Router: Wireframe

    var vc: ViewController? { get }
    var interactor: Interactor { get }
    var router: Router { get }

    init(vc: ViewController, interactor: Interactor, router: Router)
}

// MARK: - Entity
protocol Entity: Codable { }

// MARK: - Router
protocol Wireframe {
    associatedtype ViewController: UserInterface
    var vc: ViewController? { get }
    static func instantiate() -> ViewController

    func doNothing<T>(on context: T)
    func assertErrorContext(error: Error)
}

extension Wireframe where ViewController: UIViewController {
    func toSignInVc() {
        let signInVc = SignInRouter.instantiate()
        toVc(presentedVc: signInVc)
    }

    func toMainVc() {
        let mainVc = MainRouter.instantiate()
        toVc(presentedVc: mainVc)
    }

    func toVc(presentedVc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: presentedVc)
        navigationController.modalPresentationStyle = .fullScreen
        vc?.present(navigationController, animated: true)
    }

    func assertErrorContext(error: Error) {
        // do nothing
    }
}

extension Wireframe {
    func doNothing<T>(on context: T) {}
}

// MARK: - Repository
protocol Repository { }
