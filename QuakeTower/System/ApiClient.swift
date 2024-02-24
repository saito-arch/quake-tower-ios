//
//  ApiClient.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

/// - service: Expected error in the service
/// - system: Unexpected error in service
enum ErrorWrapper<T>: Error where T: Api {
    case service(error: ServiceErrors, api: T, causedBy: Error?)
    case system(error: SystemErrors, api: T, causedBy: Error?)
}

protocol ApiClient {
    func call<T>(api: T) -> Single<ApiContext<T.Response.Context, MyError>> where T: ApiVer1
}
