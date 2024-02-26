//
//  SignInSpec.swift
//  QuakeTowerTests
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import Quick
import Nimble
@testable import QuakeTower

let TIMEOUT = AsyncDefaults.timeout
let SUCCESS_RES_4_SPECS: String? = nil

class SignInViewControllerMock: SignInUserInterface {

    typealias Presenter = SignInPresenter<SignInViewControllerMock, SignInInteractor, SignInRouterMock>
    var presenter: Presenter?

    func set(presenter: Presenter) {
        self.presenter = presenter
    }

    private var embeddedClosure4AlertV2: ((AlertActionPatternV2) -> Void)?
    func embedAssertion4AlertV2(closure: @escaping ((AlertActionPatternV2) -> Void)) {
        self.embeddedClosure4AlertV2 = closure
    }
    func showAlert(
        title: String?,
        message: String,
        pattern: AlertActionPatternV2,
        handler: ((UIAlertAction) -> Void)?
    ) {
        self.embeddedClosure4AlertV2?(pattern)
        self.embeddedClosure4AlertV2 = nil
    }

    private var embeddedClosure4Alert: ((MessagePatternId) -> Void)?
    func embedAssertion4Alert(closure: @escaping ((MessagePatternId) -> Void)) {
        self.embeddedClosure4Alert = closure
    }
    func showAlert(of pattern: MessagePatternId, handler: ((UIAlertAction) -> Void)?) {
        self.embeddedClosure4Alert?(pattern)
        self.embeddedClosure4Alert = nil
    }

    // Don't use protocol method in spec
    func showIndicator() {}
    func hideIndicator() {}
}

class SignInRouterMock: SignInWireframe {

    typealias ViewController = SignInViewControllerMock

    var vc: ViewController?

    init(vc: ViewController) { self.vc = vc }

    // MARK: factory
    static func instantiate() -> ViewController {
        let vc = SignInViewControllerMock()
        let interactor = SignInInteractor()
        let router = SignInRouterMock(vc: vc)
        let presenter = SignInPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)
        return vc
    }

    func assertErrorContext(error: Error) {}
}

// MARK: - TestCases
class SignInSpec: QuickSpec {

    override func spec() {

        let vc = SignInRouterMock.instantiate()
        let presenter = vc.presenter!

        let email = "foo@bar.com"
        let password = "aA1234"

        /* Scenario 1: sign in
         * Presenter method : onTouchSignInButton
         * API              : Apis.Ver1.SignIn
         */
        describe("sign in") {
            context("when number of sign-in failures >= MAX_COUNT_SIGN_IN_FAILURE") {
                beforeEach {
                    Session.shared.countSignInFailure = MAX_COUNT_SIGN_IN_FAILURE
                }
                it("show alert 002") {
                    waitUntil(timeout: TIMEOUT) { done in
                        vc.embedAssertion4Alert { pattern in
                            expect({
                                guard case .d002 = pattern else {
                                    return .failed(reason: "wrong enum case: \(pattern)")
                                }
                                print(">>> success \(pattern)")
                                return .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.onTouchSignInButton(email: email, password: password)
                    }
                }
            }
            context("when number of sign-in failures < MAX_COUNT_SIGN_IN_FAILURE") {
                beforeEach {
                    Session.shared.countSignInFailure = 0
                }
                context("when network error") {
                    it("show alert 001") {
                        waitUntil(timeout: TIMEOUT) { done in
                            var mock = MockApiClient<Apis.Ver1.SignIn>(
                                stub: Apis.Ver1.SignIn.Response(userId: 1)
                            )
                            mock.isReachable = false
                            ApiService.set(apiClient: mock)
                            vc.embedAssertion4Alert { pattern in
                                expect({
                                    guard case .d001 = pattern else {
                                        return .failed(reason: "wrong enum case: \(pattern)")
                                    }
                                    print(">>> success \(pattern)")
                                    return .succeeded
                                }).to(succeed())
                                done()
                            }
                            presenter.onTouchSignInButton(email: email, password: password)
                        }
                    }
                }
            }
        }
    }
}
