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

    func signUp(with uuid: String, playerName: String, email: String, password: String)
    -> Single<ApiContext<SignUpEntity, MyError>> {
        let api = Apis.Ver1.SignUp(uuid: uuid, playerName: playerName, email: email, pass: password)
        return self.apiClient.call(api: api)
    }

    func fetchPlayerInfo(with uuid: String, playerId: Int64)
    -> Single<ApiContext<PlayerInfo, MyError>> {
        let api = Apis.Ver1.FetchPlayerInfo(uuid: uuid, playerId: playerId)
        return self.apiClient.call(api: api)
    }

    func command(with uuid: String, playerId: Int64, towerId: Int64, number: Int, tower: Tower? = nil)
    -> Single<ApiContext<PlayerInfo, MyError>> {
        let api = Apis.Ver1.Command(uuid: uuid, playerId: playerId, towerId: towerId, number: number, tower: tower)
        return self.apiClient.call(api: api)
    }
}
