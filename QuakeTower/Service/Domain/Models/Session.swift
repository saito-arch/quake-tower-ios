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

    var udid: String? {
        set {
            if let udid = newValue {
                Keychain.udid.store(udid)
            } else {
                Keychain.udid.delete()
            }
        }
        get {
            return Keychain.udid.load()
        }
    }

    var currentAccount = QTAccount()

    private init() {}

    func signIn(with udid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, Alternatives.SignIn>> {
        return ApiService.shared.signIn(with: udid, email: email, password: password)
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
