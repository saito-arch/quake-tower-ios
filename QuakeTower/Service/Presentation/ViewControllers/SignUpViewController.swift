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
    
    lazy var indicator: UIActivityIndicatorView? = {
        UIActivityIndicatorView.instantiate(view: self.view)
    }()

    // MARK: - Lifecycle Events

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(indicator!)
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
}
