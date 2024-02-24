//
//  Keychain.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import Security

enum Keychain: String {

    case udid

    func store(_ value: String) {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : self.rawValue,
            kSecValueData as String : value.data(using: .utf8)!
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func load() -> String? {

        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : self.rawValue,
            kSecReturnData as String : kCFBooleanTrue as Any,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == noErr else {
            return nil
        }
        guard let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func delete() {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : self.rawValue
        ]

        if errSecSuccess == SecItemDelete(query as CFDictionary) {
            log("Successfully deleted \(self)")
        } else {
            log("Failed to delete \(self)")
        }
    }
}
