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
                let userName: String

                func getContext() -> SignInEntity {
                    let entity = SignInEntity(userId: userId, userName: userName)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/auth/sign-in"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(uuid: String, email: String, pass: String) {
                self.params = ["uuid": "\(uuid)", "email": "\(email)", "pass": "\(pass)"]
            }
        }

        struct SignUp: ApiVer1 {
            typealias Response = SignUpResult

            struct SignUpResult: Codable, JudgableVer1 {
                typealias Context = SignUpEntity

                let userId: Int

                func getContext() -> SignUpEntity {
                    let entity = SignUpEntity(userId: userId)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/auth/sign-up"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(uuid: String, userName:String, email: String, pass: String) {
                self.params = ["uuid": "\(uuid)", "name": "\(userName)", "email": "\(email)", "pass": "\(pass)"]
            }
        }
    }
}
