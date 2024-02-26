//
//  SignInViewController.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit

protocol SignInUserInterface: UserInterface, Alertable where Presenter: SignInPresentation {
    func showIndicator()
    func hideIndicator()
}

class SignInViewController: UIViewController {

    var presenter: Presenter?

    @IBOutlet weak var textFieldEmail: UITextField! {
        didSet {
            self.textFieldEmail.delegate = self
        }
    }

    @IBOutlet weak var textFieldPassword: UITextField! {
        didSet {
            self.textFieldPassword.delegate = self
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

    lazy var indicator: UIActivityIndicatorView? = {
        UIActivityIndicatorView.instantiate(view: self.view)
    }()

    // MARK: - Lifecycle Events

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(indicator!)
    }
}

extension SignInViewController: SignInUserInterface {

    typealias Presenter = SignInPresenter<SignInViewController, SignInInteractor, SignInRouter>

    func set(presenter: Presenter) {
        self.presenter = presenter
    }

    func showIndicator() {
        self.indicator?.startAnimating()
    }

    func hideIndicator() {
        self.indicator?.stopAnimating()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldEmail.validate(type: .email) == .valid &&
            textFieldPassword.validate(type: .password) == .valid {
            buttonSignIn.isEnabled = true
        } else {
            buttonSignIn.isEnabled = false
        }
    }
}
