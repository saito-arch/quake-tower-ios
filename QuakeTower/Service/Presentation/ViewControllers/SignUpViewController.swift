//
//  SignUpViewController.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/26.
//

import Foundation
import UIKit

protocol SignUpUserInterface: UserInterface, Alertable where Presenter: SignUpPresentation {
    func showIndicator()
    func hideIndicator()
}

class SignUpViewController: UIViewController {

    var presenter: Presenter?

    @IBOutlet weak var textFieldPlayerName: UITextField! {
        didSet {
            self.textFieldPlayerName.delegate = self
        }
    }

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

    @IBOutlet weak var buttonSignUp: UIButton!

    lazy var indicator: UIActivityIndicatorView? = {
        UIActivityIndicatorView.instantiate(view: self.view)
    }()

    // MARK: - Lifecycle Events

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(indicator!)
    }

    // MARK: - User Actions

    @IBAction func onTouchSignUpButton(_ sender: UIButton) {
        if let playerName = textFieldPlayerName.text,
            let email = textFieldEmail.text,
            let password = textFieldPassword.text {
            presenter?.onTouchSignUpButton(playerName: playerName, email: email, password: password)
        }
    }
}

extension SignUpViewController: SignUpUserInterface {

    typealias Presenter = SignUpPresenter<SignUpViewController, SignUpInteractor, SignUpRouter>

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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldPlayerName.validate(type: .playerName) == .valid &&
            textFieldEmail.validate(type: .email) == .valid &&
            textFieldPassword.validate(type: .password) == .valid {
            buttonSignUp.isEnabled = true
        } else {
            buttonSignUp.isEnabled = false
        }
    }
}
