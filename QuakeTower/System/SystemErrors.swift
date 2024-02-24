//
//  SystemErrors.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation

enum SystemErrors: Error {

    enum Development: Error {
        case unimplemented
        case castFailure
    }

    enum Api: Error {
        case responseNil
        case deserializeFailure(responseJson: String)
        case communicationError(httpStatusCode: String)
        case httpStatusError(statusCode: Int?, description: String)
        case httpClientError(statusCode: Int?, description: String)

        case undefinedServerError(errorCd: String)
        case unexpectedServerError(errorCd: String)
        case unexpectedResponse(description: String)
        case dataConversionError(description: String)
    }

    case development(_ error: Development)
    case api(_ error: Api)
}
