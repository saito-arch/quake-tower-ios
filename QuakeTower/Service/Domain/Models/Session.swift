//
//  Session.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

class Session {

    // Singleton
    static let shared = Session()

    var uuid: String? {
        set {
            if let uuid = newValue {
                Keychain.uuid.store(uuid)
            } else {
                Keychain.uuid.delete()
            }
        }
        get {
            return Keychain.uuid.load()
        }
    }

    var currentAccount = QTAccount()

    private init() {}

    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, Alternatives.SignIn>> {
        return ApiService.shared.signIn(with: uuid, email: email, password: password)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let entity):
                    self.currentAccount.userId = entity.userId

                default:
                    break
                }
            })
    }
}
