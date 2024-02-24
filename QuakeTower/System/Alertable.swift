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
    case d001
}

let ERROR_ALERT_CONTENT_MAP: [MessagePatternId: AlertContent] = [
    .d001: AlertContent(
        title: ERR_TITLE_COMMUNICATION,
        message: nil,
        actions: [(COMMON_OK, .default)]
    )
]

enum AlertActionPatternV2 {
    case d1001
    case d2xxx
}

let ERROR_ALERT_CONTENT_MAP_V2: [AlertActionPatternV2: [(String, UIAlertAction.Style)]] = [
    .d1001: [(COMMON_OK, .default)],
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

let ERR_TITLE_COMMUNICATION = "Network error"
