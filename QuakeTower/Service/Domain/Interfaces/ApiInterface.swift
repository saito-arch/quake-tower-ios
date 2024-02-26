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
    ///   - email: user's email
    ///   - pass: user's password
    /// - Returns: Context of execution result
    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, MyError>>
}
