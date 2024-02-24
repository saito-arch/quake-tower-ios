//
//  Apis.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import Alamofire

let DEFAULT_HEADERS = HTTPHeaders(["Content-Type": "application/json"])

enum Apis {

    static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BaseAPI") as! String

    enum Ver1 {
        struct SignIn: ApiVer1 {
            typealias Response = SignInResult

            struct SignInResult: Codable, JudgableVer1 {
                typealias Context = SignInEntity

                let userId: Int

                func getContext() -> SignInEntity {
                    let entity = SignInEntity(userId: userId)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/auth/login"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(udid: String, email: String, pass: String) {
                self.params = ["udid": "\(udid)", "email": "\(email)", "pass": "\(pass)"]
            }
        }
    }
}

