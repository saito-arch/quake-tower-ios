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
    func onTouchSignUpButton(playerName: String, email: String, password: String)
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

    func onTouchSignUpButton(playerName: String, email: String, password: String) {
        signUp(playerName: playerName, email: email, password: password)
    }

    private func signUp(playerName: String, email: String, password: String) {
        let uuid = Session.shared.generateUuid()
        vc?.showIndicator()
        _ = self.interactor.signUp(uuid: uuid, playerName: playerName, email: email, password: password)
            .do(onSuccess: { _ in
                self.vc?.hideIndicator()
            }, onError: { _ in
                self.vc?.hideIndicator()
            })
            .subscribe(onSuccess: { contexts in
                self.onSuccessSignUp(contexts: contexts)
            }, onFailure: { error in
                self.onFailureSignUp(error: error)
            })
    }

    private func onSuccessSignUp(contexts: [SignUp]) {
        log(">>> contexts \(contexts)")
        let context = contexts.last
        switch context {
        case .some(.signUpSuccess):
            self.router.toMain()
        case .some(.alwaysRegistered(let title, let message)):
            self.vc?.showAlert(title: title, message: message, pattern: .d1003, handler: nil)
        case .some(.unexpectedError):
            self.vc?.showAlert(of: .d000, handler: nil)
        default:
            fatalError("\(contexts.last.debugDescription)")
        }
    }

    private func onFailureSignUp(error: Error) {
        switch error {
        case ServiceErrors.client(let clientError):
            log("Unexpected error during usecase execution: \(String(describing: clientError))")
            self.vc?.showAlert(of: .d001, handler: nil)
        /* Service Errors each API */
        case ErrorWrapper<Apis.Ver1.SignUp>.service(let serviceError, let api, let causedBy):
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
        case ErrorWrapper<Apis.Ver1.SignUp>.system(_, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(error)")
        }
    }
}
