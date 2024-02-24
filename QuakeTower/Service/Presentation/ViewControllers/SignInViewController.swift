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
}

extension SignInViewController: SignInUserInterface {

    typealias Presenter = SignInPresenter<SignInViewController, SignInInteractor, SignInRouter>

    func set(presenter: Presenter) {
        self.presenter = presenter
    }
}
