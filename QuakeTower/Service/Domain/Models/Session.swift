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
        get {
            Keychain.uuid.load()
        }
        set {
            if let uuid = newValue {
                Keychain.uuid.store(uuid)
            } else {
                Keychain.uuid.delete()
            }
        }
    }

    var currentAccount = QuakeTowerAccount()

    private init() {}

    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, MyError>> {
        ApiService.shared.signIn(with: uuid, email: email, password: password)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let entity):
                    self.uuid = uuid
                    self.currentAccount.userId = entity.userId

                default:
                    break
                }
            })
    }
}
