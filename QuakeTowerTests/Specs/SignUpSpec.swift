//
//  SignUpSpec.swift
//  QuakeTowerTests
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import Quick
import Nimble
@testable import QuakeTower

class SignUpViewControllerMock: SignUpUserInterface {

    typealias Presenter = SignUpPresenter<SignUpViewControllerMock, SignUpInteractor, SignUpRouterMock>
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

class SignUpRouterMock: SignUpWireframe {

    typealias ViewController = SignUpViewControllerMock

    var vc: ViewController?

    init(vc: ViewController) { self.vc = vc }

    // MARK: factory
    static func instantiate() -> ViewController {
        let vc = SignUpViewControllerMock()
        let interactor = SignUpInteractor()
        let router = SignUpRouterMock(vc: vc)
        let presenter = SignUpPresenter(vc: vc, interactor: interactor, router: router)
        vc.set(presenter: presenter)
        return vc
    }

    private var embeddedClosure4ToMain: (() -> Void)?
    func embedAssertion4ToMain(closure: @escaping (() -> Void)) {
        self.embeddedClosure4ToMain = closure
    }
    func toMain() {
        self.embeddedClosure4ToMain?()
        self.embeddedClosure4ToMain = nil
    }

    func assertErrorContext(error: Error) {}
}

// MARK: - TestCases
class SignUpSpec: QuickSpec {

    override func spec() {

        let vc = SignUpRouterMock.instantiate()
        let presenter = vc.presenter!

        let playerName = "saito"
        let email = "foo@bar.com"
        let password = "aA1234"

        /* Scenario 1: sign up
         * Presenter method : onTouchSignUpButton
         * API              : Apis.Ver1.SignUp
         */
        describe("sign up") {
            context("when network error") {
                it("show alert 001") {
                    waitUntil(timeout: TIMEOUT) { done in
                        var mock = MockApiClient<Apis.Ver1.SignUp>(
                            stub: Apis.Ver1.SignUp.Response(playerId: 1)
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
                        presenter.onTouchSignUpButton(playerName: playerName, email: email, password: password)
                    }
                }
            }
            context("when 2xxx error") {
                it("show alert 2xxx") {
                    waitUntil(timeout: TIMEOUT) { done in
                        let mock = MockApiClient<Apis.Ver1.SignUp>(
                            error: MyError(
                                code: 2_001,
                                message: "testErrorMessage",
                                errorTitle: "testErrorTitle",
                                retryable: false
                            )
                        )
                        ApiService.set(apiClient: mock)
                        vc.embedAssertion4AlertV2 { pattern in
                            expect({
                                guard case .d2xxx = pattern else {
                                    return .failed(reason: "wrong enum case: \(pattern)")
                                }
                                print(">>> success \(pattern)")
                                return .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.onTouchSignUpButton(playerName: playerName, email: email, password: password)
                    }
                }
            }
            context("when undefined error") {
                it("show alert 000") {
                    waitUntil(timeout: TIMEOUT) { done in
                        let mock = MockApiClient<Apis.Ver1.SignUp>(
                            error: MyError(
                                code: 1_999,
                                message: "testErrorMessage",
                                errorTitle: "testErrorTitle",
                                retryable: false
                            )
                        )
                        ApiService.set(apiClient: mock)
                        vc.embedAssertion4Alert { pattern in
                            expect({
                                guard case .d000 = pattern else {
                                    return .failed(reason: "wrong enum case: \(pattern)")
                                }
                                print(">>> success \(pattern)")
                                return .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.onTouchSignUpButton(playerName: playerName, email: email, password: password)
                    }
                }
            }
            context("when already registered") {
                it("show alert 1003") {
                    waitUntil(timeout: TIMEOUT) { done in
                        let mock = MockApiClient<Apis.Ver1.SignUp>(
                            error: MyError(
                                code: 1_003,
                                message: "testErrorMessage",
                                errorTitle: "testErrorTitle",
                                retryable: false
                            )
                        )
                        ApiService.set(apiClient: mock)
                        vc.embedAssertion4AlertV2 { pattern in
                            expect({
                                guard case .d1003 = pattern else {
                                    return .failed(reason: "wrong enum case: \(pattern)")
                                }
                                print(">>> success \(pattern)")
                                return .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.onTouchSignUpButton(playerName: playerName, email: email, password: password)
                    }
                }
            }
            context("when sign in success") {
                it("move to main screen") {
                    waitUntil(timeout: TIMEOUT) { done in
                        let mock = MockApiClient<Apis.Ver1.SignUp>(
                            stub: Apis.Ver1.SignUp.Response(playerId: 1)
                        )
                        ApiService.set(apiClient: mock)
                        presenter.router.embedAssertion4ToMain {
                            expect({
                                .succeeded
                            }).to(succeed())
                            done()
                        }
                        presenter.onTouchSignUpButton(playerName: playerName, email: email, password: password)
                    }
                }
            }
        }
    }
}
