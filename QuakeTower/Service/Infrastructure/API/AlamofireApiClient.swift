//
//  AlamofireApiClient.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift
import Alamofire

class AlamofireApiClient: ApiClient {
    private(set) var reachabilityManager: NetworkReachabilityManager?
    private(set) var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown

    init() {
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening(onUpdatePerforming: { status in
                self.reachabilityStatus = status
                print("change reachabilityStatus: \(status)")
            })
            self.reachabilityStatus = reachabilityManager.status
            self.reachabilityManager = reachabilityManager
            print("init ReachabilityStatus: \(self.reachabilityStatus)")
        }
    }

    // TODO: Refactoring
    func call<T>(api: T) -> Single<ApiContext<T.Response.Context, MyError>> where T: ApiVer1 {

        guard case .reachable = reachabilityStatus else {
            return Single<ApiContext<T.Response.Context, MyError>>.error(ErrorWrapper.service(error: ServiceErrors.client(.disconnection), api: api, causedBy: nil))
        }

        return Single<ApiContext<T.Response.Context, MyError>>.create { singleEvent in
            print(">>>>> API Request: \(api.url) with \(api.params)")
            let request = AF.request(api.url, method: api.method, parameters: api.params, encoding: JSONEncoding.default, headers: api.headers)
                .validate(statusCode: 200..<300)
                .responseData { response in

                    guard let data = response.data else {
                        return singleEvent(.failure(ErrorWrapper.system(error: SystemErrors.api(.responseNil), api: api, causedBy: nil)))
                    }

                    switch response.result {
                    case .success:
                        do {
                            let response = try api.deserialize(data)

                            let context = response.getContext()

                            return singleEvent(.success(.success(entity: context)))
                        } catch let error {
                            return singleEvent(.failure(ErrorWrapper.system(error: SystemErrors.api(.deserializeFailure(responseJson: String(data: data, encoding: .utf8) ?? "* Couldn't even convert it to string")), api: api, causedBy: error)))
                        }
                    case .failure(let error):

                        switch error {
                        case .responseValidationFailed(let reason):

                            switch reason {
                            case .unacceptableStatusCode(let code):
                                guard let myError = try? api.deserializeMyError(data) else {
                                    return singleEvent(.failure(ErrorWrapper.system(error: SystemErrors.api(.httpStatusError(statusCode: code, description: "\(reason): \(error.localizedDescription)")), api: api, causedBy: error)))
                                }
                                if case 1_000..<2_000 = myError.code {
                                    return singleEvent(.success(ApiContext<T.Response.Context, MyError>.failure(by: myError)))
                                } else {
                                    return singleEvent(.failure(ErrorWrapper.service(error: .myError(myError), api: api, causedBy: error)))
                                }
                            default:
                                return singleEvent(.failure(ErrorWrapper.system(error: SystemErrors.api(.httpStatusError(statusCode: response.response?.statusCode, description: "\(reason): \(error.localizedDescription)")), api: api, causedBy: error)))
                            }
                        default:
                            return singleEvent(.failure(ErrorWrapper.system(error: SystemErrors.api(.httpClientError(statusCode: response.response?.statusCode, description: error.localizedDescription)), api: api, causedBy: error)))
                        }

                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
}
