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

                let playerId: Int64
                let playerName: String

                func getContext() -> SignInEntity {
                    let entity = SignInEntity(playerId: playerId, playerName: playerName)

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

                let playerId: Int64

                func getContext() -> SignUpEntity {
                    let entity = SignUpEntity(playerId: playerId)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/auth/sign-up"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(uuid: String, playerName: String, email: String, pass: String) {
                self.params = ["uuid": "\(uuid)", "name": "\(playerName)", "email": "\(email)", "pass": "\(pass)"]
            }
        }

        struct FetchPlayerInfo: ApiVer1 {
            typealias Response = FetchPlayerInfoResult

            struct FetchPlayerInfoResult: Codable, JudgableVer1 {
                typealias Context = PlayerInfo

                let gold: Int
                let goldHour: Int
                let towers: [Tower]
                let gameInfo: GameInfo

                func getContext() -> PlayerInfo {
                    let entity = PlayerInfo(gold: gold, goldHour: goldHour, towers: towers, gameInfo: gameInfo)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/game/player-info"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(uuid: String, playerId: Int64) {
                self.params = ["uuid": "\(uuid)", "playerId": "\(playerId)"]
            }
        }

        struct Command: ApiVer1 {
            typealias Response = CommandResult

            struct CommandResult: Codable, JudgableVer1 {
                typealias Context = PlayerInfo

                let gold: Int
                let goldHour: Int
                let towers: [Tower]
                let gameInfo: GameInfo

                func getContext() -> PlayerInfo {
                    let entity = PlayerInfo(gold: gold, goldHour: goldHour, towers: towers, gameInfo: gameInfo)

                    return entity
                }
            }

            let method = HTTPMethod.post
            let url = baseUrl + "/v1/game/command"
            var headers: HTTPHeaders? = DEFAULT_HEADERS
            let params: [String: Any]

            init(uuid: String, playerId: Int64, towerId: Int64, number: Int, tower: Tower) {
                self.params = ["uuid": "\(uuid)", "playerId": "\(playerId)", "towerId": "\(towerId)", "number": "\(number)", "tower": "\(tower)"]
            }
        }
    }
}
