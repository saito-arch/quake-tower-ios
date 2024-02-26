//
//  ApiService.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

class ApiService {
    // Singleton
    static let shared: ApiInterface = ApiService()

    private(set) var apiClient: ApiClient = AlamofireApiClient()

    private init() {}

    static func set(apiClient: ApiClient) {
        (ApiService.shared as! ApiService).apiClient = apiClient
    }

    static func reset() {
        (ApiService.shared as! ApiService).apiClient = AlamofireApiClient()
    }
}

extension ApiService: ApiInterface {
    func signIn(with uuid: String, email: String, password: String) -> Single<ApiContext<SignInEntity, MyError>> {
        let api = Apis.Ver1.SignIn(uuid: uuid, email: email, pass: password)
        return self.apiClient.call(api: api)
    }

    func signUp(with uuid: String, userName: String, email: String, password: String) -> Single<ApiContext<SignUpEntity, MyError>> {
        let api = Apis.Ver1.SignUp(uuid: uuid, userName: userName, email: email, pass: password)
        return self.apiClient.call(api: api)
    }
}
