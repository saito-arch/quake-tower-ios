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
    func onTouchSignInButton(email: String, password: String)
    func onTouchSignUpButton()
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

    func onTouchSignInButton(email: String, password: String) {
        if Session.shared.countSignInFailure < MAX_COUNT_SIGN_IN_FAILURE {
            signIn(email: email, password: password)
        } else {
            vc?.showAlert(of: .d002, handler: nil)
        }
    }

    func onTouchSignUpButton() {
        // TODO: to sign up screen
    }

    private func signIn(email: String, password: String) {
        let uuid = UUID().uuidString
        vc?.showIndicator()
        _ = self.interactor.signIn(uuid: uuid, email: email, password: password)
            .do(onSuccess: { _ in
                self.vc?.hideIndicator()
            }, onError: { _ in
                self.vc?.hideIndicator()
            })
            .subscribe(onSuccess: { contexts in
                self.onSuccessSignIn(contexts: contexts)
            }, onFailure: { error in
                self.onFailureSignIn(error: error)
            })
    }

    private func onSuccessSignIn(contexts: [SignIn]) {
        log(">>> contexts \(contexts)")
        let context = contexts.last
        switch context {
        case .some(.signInSuccess):
            // TODO: to main screen
            Session.shared.countSignInFailure = 0
            break
        case .some(.signInFailure(let title, let message)):
            Session.shared.countSignInFailure += 1
            self.vc?.showAlert(title: title, message: message, pattern: .d1002, handler: nil)
        case .some(.unexpectedError):
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(contexts.last.debugDescription)")
        }
    }

    private func onFailureSignIn(error: Error) {
        switch error {
        case ServiceErrors.client(let clientError):
            log("Unexpected error during usecase execution: \(String(describing: clientError))")
            switch clientError {
            case .disconnection:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* Service Errors each API */
        case ErrorWrapper<Apis.Ver1.SignIn>.service(let serviceError, let api, let causedBy):
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
        case ErrorWrapper<Apis.Ver1.SignIn>.system(_, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(error)")
        }
    }
}
