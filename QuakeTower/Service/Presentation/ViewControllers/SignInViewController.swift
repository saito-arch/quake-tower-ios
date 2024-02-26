//
//  SignInViewController.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit

protocol SignInUserInterface: UserInterface, Alertable where Presenter: SignInPresentation {
}

class SignInViewController: UIViewController {

    var presenter: Presenter?

    @IBOutlet weak var textFieldEmail: UITextField!

    @IBOutlet weak var textFieldPassword: UITextField! {
        didSet {
            self.textFieldPassword.isSecureTextEntry = true
        }
    }

    @IBOutlet weak var buttonSignIn: UIButton!

    @IBAction func onTouchSignInButton(_ sender: UIButton) {
        if let email = textFieldEmail.text, let password = textFieldPassword.text {
            presenter?.onTouchSignInButton(email: email, password: password)
        }
    }

    @IBAction func onTouchSignUpButton(_ sender: UIButton) {
        presenter?.onTouchSignUpButton()
    }
}

extension SignInViewController: SignInUserInterface {

    typealias Presenter = SignInPresenter<SignInViewController, SignInInteractor, SignInRouter>

    func set(presenter: Presenter) {
        self.presenter = presenter
    }
}
