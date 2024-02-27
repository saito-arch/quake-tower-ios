//
//  Alertable.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit

protocol Alertable {
    func showAlert(of pattern: MessagePatternId, handler: ((UIAlertAction) -> Void)?)
    func showAlert(title: String?, message: String, pattern: AlertActionPatternV2, handler: ((UIAlertAction) -> Void)?)
}

struct AlertContent {
    let title: String?
    let message: String?
    let actions: [(String, UIAlertAction.Style)]
}

enum MessagePatternId {
    case d000
    case d001
    case d002
    case d003
}

let ERROR_ALERT_CONTENT_MAP: [MessagePatternId: AlertContent] = [
    .d000: AlertContent(
        title: ERR_TITLE_UNEXPECTED,
        message: ERR_MESSAGE_UNEXPECTED,
        actions: [(COMMON_OK, .default)]
    ),
    .d001: AlertContent(
        title: ERR_TITLE_COMMUNICATION,
        message: nil,
        actions: [(COMMON_OK, .default)]
    ),
    .d002: AlertContent(
        title: ERR_TITLE_LIMIT_SIGN_IN_FAILURE,
        message: ERR_MESSAGE_LIMIT_SIGN_IN_FAILURE,
        actions: [(COMMON_OK, .default)]
    ),
    .d003: AlertContent(
        title: ERR_TITLE_ID_PROBLEM,
        message: ERR_MESSAGE_ID_PROBLEM,
        actions: [(COMMON_OK, .default)]
    )
]

enum AlertActionPatternV2 {
    case d1001
    case d1002
    case d1003
    case d2xxx
}

let ERROR_ALERT_CONTENT_MAP_V2: [AlertActionPatternV2: [(String, UIAlertAction.Style)]] = [
    .d1001: [(COMMON_OK, .default)],
    .d1002: [(COMMON_OK, .default)],
    .d1003: [(COMMON_OK, .default)],
    .d2xxx: [(COMMON_OK, .default)]
]

extension Alertable {
    func showAlert(of pattern: MessagePatternId, handler: ((UIAlertAction) -> Void)? = nil) {
        print("\(pattern)")

        guard let selfVc = self as? UIViewController else { return }

        let content = self.getAlertContent(by: pattern)

        DispatchQueue.main.async {
            let alert = UIAlertController(title: content.title, message: content.message, preferredStyle: .alert)

            content.actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.0, style: action.1, handler: handler))
            }
            selfVc.present(alert, animated: true, completion: nil)
        }
    }

    func showAlert(
        title: String?,
        message: String,
        pattern: AlertActionPatternV2,
        handler: ((UIAlertAction) -> Void)?
    ) {
        print("\(pattern)")

        guard let selfVc = self as? UIViewController else { return }

        let actions = self.getAlertContentV2(by: pattern)

        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.0, style: action.1, handler: handler))
            }
            selfVc.present(alert, animated: true, completion: nil)
        }
    }

    private func getAlertContent(by pattern: MessagePatternId) -> AlertContent {
        guard let content = ERROR_ALERT_CONTENT_MAP[pattern] else {
            return AlertContent(title: "\(pattern)", message: "ERROR", actions: [(COMMON_OK, .default)])
        }
        return content
    }

    private func getAlertContentV2(by pattern: AlertActionPatternV2) -> [(String, UIAlertAction.Style)] {
        guard let actions = ERROR_ALERT_CONTENT_MAP_V2[pattern] else {
            return [(COMMON_OK, .default)]
        }
        return actions
    }
}

let COMMON_OK = "OK"

let ERR_TITLE_UNEXPECTED = "Unexpected error"
let ERR_MESSAGE_UNEXPECTED = "An unexpected error has occurred."
let ERR_TITLE_COMMUNICATION = "Network error"
let ERR_TITLE_LIMIT_SIGN_IN_FAILURE = "Can't sign in"
let ERR_MESSAGE_LIMIT_SIGN_IN_FAILURE = "The number of failed sign in attempts has reached the limit."
let ERR_TITLE_ID_PROBLEM = "Unusual state"
let ERR_MESSAGE_ID_PROBLEM = "There was a problem with your registration information. Sign out."
