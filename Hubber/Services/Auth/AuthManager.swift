//
//  AuthManager.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation

class AuthManager: NSObject {

    struct AuthKeys {

        enum UserDataKeys: String {
            case login = "login"
            case password = "pass"
            case token = "access_token"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
            case currentUserID = "id"
        }
    }

    static private (set) var shared = AuthManager()
    private var defaults = UserDefaults.standard

    func isUserLogged() -> Bool {
        return self.checkForExist(key: .token)
    }
    var token: String? {
        set {
            guard let token = newValue else { return }
            self.setData(keys: [(value: token, key: .token)])
        }
        get { return self.string(by: .token)  }
    }

    func signOut() { self.removeKeys(keys: [.token]) }

    private func removeKeys(keys: [AuthKeys.UserDataKeys]) {
        keys.forEach { self.defaults.removeObject(forKey: $0.rawValue) }
    }

    private func setData(keys: [(value: String, key: AuthKeys.UserDataKeys)]) {
        keys.forEach { self.defaults.set($0.value, forKey: $0.key.rawValue) }
    }
    private func checkForExist(key: AuthKeys.UserDataKeys) -> Bool {
        return (self.defaults.value(forKey: key.rawValue) != nil)
    }

    private func string(by key: AuthKeys.UserDataKeys) -> String? {
        return self.defaults.string(forKey: key.rawValue)
    }

    private func integer(by key: AuthKeys.UserDataKeys) -> Int {
        return self.defaults.integer(forKey: key.rawValue)
    }

}
