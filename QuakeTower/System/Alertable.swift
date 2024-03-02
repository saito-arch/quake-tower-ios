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
    case d004
    case d005
}

let ALERT_CONTENT_MAP: [MessagePatternId: AlertContent] = [
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
    ),
    .d004: AlertContent(
        title: ERR_TITLE_NOT_ENOUGH_GOLD,
        message: ERR_MESSAGE_NOT_ENOUGH_GOLD,
        actions: [(COMMON_OK, .default)]
    ),
    .d005: AlertContent(
        title: nil,
        message: ERR_MESSAGE_TOWER_IS_COLLAPSED,
        actions: [(COMMON_OK, .default)]
    )
]

enum AlertActionPatternV2 {
    case d1001
    case d1002
    case d1003
    case d2xxx
    case command
}

let ALERT_CONTENT_MAP_V2: [AlertActionPatternV2: [(String, UIAlertAction.Style)]] = [
    .d1001: [(COMMON_OK, .default)],
    .d1002: [(COMMON_OK, .default)],
    .d1003: [(COMMON_OK, .default)],
    .d2xxx: [(COMMON_OK, .default)],
    .command: [(COMMON_OK, .default), (COMMON_CANCEL, .cancel)]
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
        guard let content = ALERT_CONTENT_MAP[pattern] else {
            return AlertContent(title: "\(pattern)", message: "ERROR", actions: [(COMMON_OK, .default)])
        }
        return content
    }

    private func getAlertContentV2(by pattern: AlertActionPatternV2) -> [(String, UIAlertAction.Style)] {
        guard let actions = ALERT_CONTENT_MAP_V2[pattern] else {
            return [(COMMON_OK, .default)]
        }
        return actions
    }
}

let COMMON_OK = "OK"
let COMMON_CANCEL = "cancel"

let ERR_TITLE_UNEXPECTED = "Unexpected error"
let ERR_MESSAGE_UNEXPECTED = "An unexpected error has occurred."
let ERR_TITLE_COMMUNICATION = "Network error"
let ERR_TITLE_LIMIT_SIGN_IN_FAILURE = "Can't sign in"
let ERR_MESSAGE_LIMIT_SIGN_IN_FAILURE = "The number of failed sign in attempts has reached the limit."
let ERR_TITLE_ID_PROBLEM = "Unusual state"
let ERR_MESSAGE_ID_PROBLEM = "There was a problem with your registration information. Sign out."
let ERR_TITLE_NOT_ENOUGH_GOLD = "Not enough G"
let ERR_MESSAGE_NOT_ENOUGH_GOLD = "G required for this command is missing."
let ERR_MESSAGE_TOWER_IS_COLLAPSED = "This tower has already collapsed."

let TITLE_COMMAND = "Confirmation"
let MESSAGE_BUILD = "Build command needs %dG. Do you build tower in %@?"
let MESSAGE_EXTEND = "Extend command needs %dG. Do you extend tower?"
let MESSAGE_REINFORCE = "Reinforce command needs %dG. Do you reinforce tower?"
let MESSAGE_REPAIR = "Repair command needs %dG. Do you repair tower?"
