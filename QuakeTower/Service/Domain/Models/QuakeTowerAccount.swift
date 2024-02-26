//
//  QuakeTowerAccount.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

class QuakeTowerAccount {
    var userId: Int? {
        get {
            if let userId = Stored.IntValue.userId.object() {
                return userId
            } else {
                return nil
            }
        }
        set {
            if let userId = newValue {
                Stored.IntValue.userId.set(userId)
            } else {
                Stored.IntValue.userId.removeObject()
            }
        }
    }

    var userName: String? {
        get {
            if let userName = Stored.StringValue.userName.object() {
                return userName
            } else {
                return nil
            }
        }
        set {
            if let userName = newValue {
                Stored.StringValue.userName.set(userName)
            } else {
                Stored.StringValue.userName.removeObject()
            }
        }
    }

    init() {}
}
