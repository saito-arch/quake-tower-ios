//
//  SignUpInteractor.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import RxSwift

enum SignUp: Scenario {
    case signUpReady(uuid: String, playerName: String, email: String, password: String)
    case signUpSuccess
    case alwaysRegistered(title: String?, message: String)
    case unexpectedError

    init(uuid: String, playerName: String, email: String, password: String) {
        self = .signUpReady(uuid: uuid, playerName: playerName, email: email, password: password)
    }

    func signUp(with uuid: String, playerName: String, email: String, password: String) -> Single<SignUp> {
        Session.shared.signUp(with: uuid, playerName: playerName, email: email, password: password)
            .map { apiContext -> SignUp in
                switch apiContext {
                case .success:
                    return .signUpSuccess
                case .failure(let myError):
                    switch myError.code {
                    case ServiceErrors.Server.Ver1.alwaysRegistered.rawValue:
                        return .alwaysRegistered(title: myError.errorTitle, message: myError.message)
                    default:
                        return .unexpectedError
                    }
                }
            }
    }

    func next() -> Single<SignUp>? {
        switch self {
        case .signUpReady(let uuid, let playerName, let email, let password):
            return signUp(with: uuid, playerName: playerName, email: email, password: password)

        case .signUpSuccess,
            .alwaysRegistered,
            .unexpectedError:
            return nil
        }
    }
}

protocol SignUpUsecase: Usecase {
    /// usecase "SignUp"
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - playerName: user's name
    ///   - email: user's email
    ///   - password: user's password
    /// - Returns: Context of execution result
    func signUp(uuid: String, playerName: String, email: String, password: String) -> Single<[SignUp]>
}

struct SignUpInteractor: SignUpUsecase {
    func signUp(uuid: String, playerName: String, email: String, password: String) -> Single<[SignUp]> {
        self.interact(contexts: [SignUp(uuid: uuid, playerName: playerName, email: email, password: password)])
    }
}
