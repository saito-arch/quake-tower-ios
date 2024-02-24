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
    func signIn(with udid: String, email: String, pass: String) -> Single<ApiContext<SignInEntity, MyError>> {
        let api = Apis.Ver1.SignIn(udid: udid, email: email, pass: pass)
        return self.apiClient.call(api: api)
    }
}
