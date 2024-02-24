//
//  Api.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import Alamofire

struct MyError: Codable, Error {
    let code: Int
    let message: String
    let errorTitle: String?
    let retryable: Bool?
}

protocol Api {
    var method: HTTPMethod { get }
    var url: String { get }
    var headers: HTTPHeaders? { get set }
    var params: [String: Any] { get }
}

protocol JudgableVer1 {
    associatedtype Context

    func getContext() -> Context
}

protocol ApiVer1: Api {
    associatedtype Response: Codable, JudgableVer1

    func deserialize(_ json: Data) throws -> Response
    func deserializeMyError(_ json: Data) throws -> MyError
}

extension ApiVer1 {
    func deserialize(_ json: Data) throws -> Response {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: json)
    }
    func deserializeMyError(_ json: Data) throws -> MyError {
        try JSONDecoder().decode(MyError.self, from: json)
    }
}
