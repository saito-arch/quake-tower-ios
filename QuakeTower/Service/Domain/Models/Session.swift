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

    var countSignInFailure: Int {
        get {
            if let countSignInFailure = Stored.IntValue.countSignInFailure.object() {
                return countSignInFailure
            } else {
                return 0
            }
        }
        set {
            Stored.IntValue.countSignInFailure.set(newValue)
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
                    self.currentAccount.userName = entity.userName

                default:
                    break
                }
            })
    }

    func signUp(with uuid: String, userName: String, email: String, password: String) -> Single<ApiContext<SignUpEntity, MyError>> {
        ApiService.shared.signUp(with: uuid, userName: userName, email: email, password: password)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let entity):
                    self.uuid = uuid
                    self.currentAccount.userId = entity.userId
                    self.currentAccount.userName = userName

                default:
                    break
                }
            })
    }
}
