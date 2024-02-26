//
//  SignInInteractor.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

enum SignIn: Scenario {
    case signInReady(uuid: String, email: String, password: String)
    case signInSuccess
    case signInFailure(title: String?, message: String)
    case unexpectedError

    init(uuid: String, email: String, password: String) {
        self = .signInReady(uuid: uuid, email: email, password: password)
    }

    func signIn(with uuid: String, email: String, password: String) -> Single<SignIn> {
        Session.shared.signIn(with: uuid, email: email, password: password)
            .map { apiContext -> SignIn in
                switch apiContext {
                case .success:
                    return .signInSuccess
                case .failure(let myError):
                    switch myError.code {
                    case ServiceErrors.Server.Ver1.signInFailure.rawValue:
                        return .signInFailure(title: myError.errorTitle, message: myError.message)
                    default:
                        return .unexpectedError
                    }
                }
            }
    }

    func next() -> Single<SignIn>? {
        switch self {
        case .signInReady(let uuid, let email, let password):
            return signIn(with: uuid, email: email, password: password)

        case .signInSuccess,
            .signInFailure,
            .unexpectedError:
            return nil
        }
    }
}

protocol SignInUsecase: Usecase {
    /// usecase "SignIn"
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - email: user's email
    ///   - password: user's password
    /// - Returns: Context of execution result
    func signIn(uuid: String, email: String, password: String) -> Single<[SignIn]>
}

struct SignInInteractor: SignInUsecase {
    func signIn(uuid: String, email: String, password: String) -> Single<[SignIn]> {
        self.interact(contexts: [SignIn(uuid: uuid, email: email, password: password)])
    }
}
