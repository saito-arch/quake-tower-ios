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

    private func fetchPlayerInfo() {
        vc?.showIndicator()
        _ = self.interactor.fetchPlayerInfo()
            .do(onSuccess: { _ in
                self.vc?.hideIndicator()
            }, onError: { _ in
                self.vc?.hideIndicator()
            })
            .subscribe(onSuccess: { contexts in
                self.onSuccessFetchPlayerInfo(contexts: contexts)
            }, onFailure: { error in
                self.onFailureFetchPlayerInfo(error: error)
            })
    }

    private func onSuccessFetchPlayerInfo(contexts: [FetchPlayerInfo]) {
        log(">>> contexts \(contexts)")
        let context = contexts.last
        switch context {
        case .some(.fetchPlayerInfoSuccess):
            // TODO: reflect info on the screen
            break
        case .some(.idsMismatch(let title, let message)):
            self.vc?.showAlert(of: .d003) { [weak self] action in
                // TODO: sign out
            }
        case .some(.unexpectedError):
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(contexts.last.debugDescription)")
        }
    }

    private func onFailureFetchPlayerInfo(error: Error) {
        switch error {
        case ServiceErrors.client(let clientError):
            log("Unexpected error during usecase execution: \(String(describing: clientError))")
            switch clientError {
            case .idsDoNotExist:
                self.vc?.showAlert(of: .d003) { [weak self] action in
                    // TODO: sign out
                }
            default:
                self.vc?.showAlert(of: .d001, handler: nil)
            }
        /* Service Errors each API */
        case ErrorWrapper<Apis.Ver1.FetchPlayerInfo>.service(let serviceError, let api, let causedBy):
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
        case ErrorWrapper<Apis.Ver1.FetchPlayerInfo>.system(_, let api, let causedBy):
            log("Error on \(api) calling: \(String(describing: causedBy))")
            self.vc?.showAlert(of: .d001, handler: nil)
        default:
            fatalError("\(error)")
        }
    }
}
