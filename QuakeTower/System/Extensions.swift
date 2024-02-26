//
//  Extensions.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/25.
//

import Foundation
import UIKit

enum ValidationResult {
    case valid
    case invalid(ValidationError)
}

extension ValidationResult: Equatable {
    static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid):
            return true
        case (.invalid, .valid):
            return false
        case (.valid, .invalid):
            return false
        case (.invalid, .invalid):
            return true
        }
    }
}

protocol ValidationErrorProtocol: LocalizedError { }

enum ValidationError: ValidationErrorProtocol {

    case empty
    case length(min: Int, max: Int)
    case userNameFormat
    case emailFormat

    var errorDescription: String? {
        switch self {
        case .empty: return "Please enter some characters"
        case .length(let min, let max): return "Please enter between \(min) and \(max) characters"
        case .userNameFormat: return "Please enter letters or numbers"
        case .emailFormat: return "Please enter a valid email address"
        }
    }
}

protocol Validator {
    func validate(_ value: String) -> ValidationResult
}

protocol CompositeValidator: Validator {
    var validators: [Validator] { get }
    func validate(_ value: String) -> ValidationResult
}

extension CompositeValidator {

    func validate(_ value: String) -> [ValidationResult] {
        validators.map { $0.validate(value) }
    }

    func validate(_ value: String) -> ValidationResult {
        let results: [ValidationResult] = validate(value)

        let errors = results.filter { result -> Bool in
            switch result {
            case .valid: return false
            case .invalid: return true
            }
        }
        return errors.first ?? .valid
    }
}

struct EmptyValidator: Validator {

    func validate(_ value: String) -> ValidationResult {
        if value.isEmpty == true {
            return .invalid(.empty)
        } else {
            return .valid
        }
    }
}

struct LengthValidator: Validator {
    let min: Int
    let max: Int

    func validate(_ value: String) -> ValidationResult {
        if value.count >= min && value.count <= max {
            return .valid
        } else {
            return .invalid(.length(min: min, max: max))
        }
    }
}

struct UserNameFormatValidator: Validator {

    let regExpression = "^[a-zA-Z0-9]+$"

    func validate(_ value: String) -> ValidationResult {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        let result = predicate.evaluate(with: value)

        switch result {
        case true: return .valid
        case false: return .invalid(.userNameFormat)
        }
    }
}

struct EmailFormatValidator: Validator {

    let regExpression = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"

    func validate(_ value: String) -> ValidationResult {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExpression)
        let result = predicate.evaluate(with: value)

        switch result {
        case true: return .valid
        case false: return .invalid(.userNameFormat)
        }
    }
}

struct UserNameValidator: CompositeValidator {
    var validators: [Validator] = [
        LengthValidator(min: 1, max: 8),
        UserNameFormatValidator()
    ]
}

struct EmailValidator: CompositeValidator {
    var validators: [Validator] = [
        EmailFormatValidator()
    ]
}

struct PasswordValidator: CompositeValidator {
    var validators: [Validator] = [
        LengthValidator(min: 6, max: 12)
    ]
}

extension UITextField {
    enum ValidateType {
        case userName
        case email
        case password
    }

    @discardableResult
    func validate(type: ValidateType) -> ValidationResult {
        switch type {
        case .userName:
            return UserNameValidator().validate(text ?? "")
        case .email:
            return EmailValidator().validate(text ?? "")
        case .password:
            return PasswordValidator().validate(text ?? "")
        }
    }
}
