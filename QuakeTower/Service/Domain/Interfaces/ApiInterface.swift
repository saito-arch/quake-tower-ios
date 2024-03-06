//
//  ApiInterface.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

enum ApiContext<T, Alternatives> {
    case success(entity: T)
    case failure(by: Alternatives)
}

enum Alternatives {

    enum None {}

    case none(_ error: None)
}

protocol ApiInterface {
    /// Execute to sign in
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - email: player's email
    ///   - pass: player's password
    /// - Returns: Context of execution result
    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, MyError>>

    /// Execute to sign up
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - playerName: player's name
    ///   - email: player's email
    ///   - pass: player's password
    /// - Returns: Context of execution result
    func signUp(with uuid: String, playerName: String, email: String, password: String)
    -> Single<ApiContext<SignUpEntity, MyError>>

    /// Fetch player info
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - playerId: player's ID
    /// - Returns: Context of execution result
    func fetchPlayerInfo(with uuid: String, playerId: Int64)
    -> Single<ApiContext<PlayerInfo, MyError>>

    /// Command build, extend, reinforce, or repair
    ///
    /// - Parameters:
    ///   - uuid: Terminal identification ID
    ///   - playerId: player's ID
    ///   - towerId: tower's ID
    ///   - number: command's number
    ///   - tower: (build only) building tower
    /// - Returns: Context of execution result
    func command(with uuid: String, playerId: Int64, towerId: Int64, number: Int, tower: Tower?)
    -> Single<ApiContext<PlayerInfo, MyError>>
}
