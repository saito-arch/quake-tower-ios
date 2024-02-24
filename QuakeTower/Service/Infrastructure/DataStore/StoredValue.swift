//
//  StoredValue.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation

enum Stored {

    enum IntValue: String, UserDefaultsKey {
        typealias ValueType = Int

        case id
    }
}

protocol UserDefaultsKey: RawRepresentable where RawValue == String {
    associatedtype ValueType
}

extension UserDefaultsKey {

    func set(_ value: ValueType) {
        if IS_TESTING {
            MockUserDefaults.shared.set(value: value, forKey: self.rawValue)
        } else {
            UserDefaults.standard.set(value, forKey: self.rawValue)
        }
    }

    func object() -> ValueType? {
        if IS_TESTING {
            return MockUserDefaults.shared.object(forKey: self.rawValue) as? ValueType
        } else {
            return UserDefaults.standard.object(forKey: self.rawValue) as? ValueType
        }
    }

    func removeObject() {
        if IS_TESTING {
            MockUserDefaults.shared.removeObject(forKey: self.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: self.rawValue)
        }
    }
}

fileprivate class MockUserDefaults {

    static let shared = MockUserDefaults()

    private init() {}

    var storedValues = [Keys: Any?]()

    enum Keys: String {
        case id
    }

    private func searchKey(forKey: String) -> Keys? {
        guard let key = Keys(rawValue: forKey) else { return nil }
        return key
    }

    func set(value: Any?, forKey: String) {
        guard let key = searchKey(forKey: forKey) else {
            log("forKey >>> \(forKey)")
            fatalError()
        }
        storedValues[key] = value
    }

    func object(forKey: String) -> Any? {
        guard let key = searchKey(forKey: forKey) else {
            log("forKey >>> \(forKey)")
            fatalError()
        }
        return storedValues[key] as Any?
    }

    func removeObject(forKey: String) {
        guard let key = searchKey(forKey: forKey) else {
            log("forKey >>> \(forKey)")
            fatalError()
        }
        storedValues[key] = nil
    }
}
