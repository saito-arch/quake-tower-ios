//
//  MockApClient.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import RxSwift

enum ApiResult<T> {
    case context(T)
    case errorWrapper(Error)
}

struct MockApiClient<U>: ApiClient where U: ApiVer1 {
    var isReachable = true

    let stub: U.Response?
    let error: MyError?
    let beforeCall: ((U) -> Void)?
    let afterCall: ((ApiResult<ApiContext<U.Response.Context, MyError>>) -> Void)?

    init(
        stub: U.Response? = nil,
        error: MyError? = nil,
        beforeCall: ((U) -> Void)? = nil,
        afterCall: ((ApiResult<ApiContext<U.Response.Context, MyError>>) -> Void)? = nil
    ) {
        self.stub = stub
        self.error = error
        self.beforeCall = beforeCall
        self.afterCall = afterCall
    }

    func call<T>(api: T) -> Single<ApiContext<T.Response.Context, MyError>> where T: ApiVer1 {

        guard let _api = api as? U else {
            return Single<ApiContext<T.Response.Context, MyError>>.error(
                TestingError.preparedApiStubDoesNotAlignWithCalledApi(
                    message: "mocking: \(U.self), called: \(type(of: api))"
                )
            )
        }

        self.beforeCall?(_api)

        guard isReachable else {
            return Single<ApiContext<T.Response.Context, MyError>>.error(
                ErrorWrapper.service(
                    error: ServiceErrors.client(.disconnection),
                    api: api,
                    causedBy: ServiceErrors.Client.disconnection
                )
            )
        }

        return Single<ApiContext<T.Response.Context, MyError>>.create { singleEvent in
            do {
                var data: Data?
                if self.stub != nil {
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.dateEncodingStrategy = .iso8601
                    data = try jsonEncoder.encode(self.stub)
                    let entity = try api.deserialize(data!)

                    let context = entity.getContext()

                    singleEvent(.success(.success(entity: context)))
                } else if self.error != nil {
                    data = try JSONEncoder().encode(self.error)
                    let myError = try api.deserializeMyError(data!)

                    if case 1_000..<2_000 = myError.code {
                        singleEvent(.success(ApiContext<T.Response.Context, MyError>.failure(by: myError)))
                    } else {
                        singleEvent(.failure(
                            ErrorWrapper.service(error: .myError(myError), api: api, causedBy: self.error)
                        ))
                    }
                }
            } catch {
                singleEvent(.failure(error))
            }
            return Disposables.create {}
        }
        .do(onSuccess: { context in
            if let afterCall = self.afterCall {
                afterCall(.context(context as! ApiContext<U.Response.Context, MyError>))
            } else {
                ApiService.reset()
            }
        }, onError: { error in
            if let afterCall = self.afterCall {
                afterCall(.errorWrapper(error))
            } else {
                ApiService.reset()
            }
        })
    }
}
