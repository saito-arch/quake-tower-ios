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

                let id: Int

                func getContext() -> SignInEntity {
                    let entity = SignInEntity(id: id)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/auth/login"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(deviceId: String, accessToken: String) {
                self.params = ["deviceId": "\(deviceId)", "accessToken": "\(accessToken)"]
            }
        }
    }
}

