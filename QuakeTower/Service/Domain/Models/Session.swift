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

    func generateUuid() -> String {
        if let uuid = self.uuid {
            return uuid
        }
        let newUuid = UUID().uuidString
        self.uuid = newUuid

        return newUuid
    }

    private init() {}

    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, MyError>> {
        ApiService.shared.signIn(with: uuid, email: email, password: password)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let entity):
                    self.currentAccount.playerId = entity.playerId
                    self.currentAccount.playerName = entity.playerName

                default:
                    break
                }
            })
    }

    func signUp(with uuid: String, playerName: String, email: String, password: String)
    -> Single<ApiContext<SignUpEntity, MyError>> {
        ApiService.shared.signUp(with: uuid, playerName: playerName, email: email, password: password)
            .do(onSuccess: { apiContext in

                switch apiContext {
                case .success(let entity):
                    self.currentAccount.playerId = entity.playerId
                    self.currentAccount.playerName = playerName

                default:
                    break
                }
            })
    }
}
