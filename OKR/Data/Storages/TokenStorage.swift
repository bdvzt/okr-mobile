//
//  TokenStorage.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

final class TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "accessToken"

    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }

    func retrieveToken() -> String? {
        userDefaults.string(forKey: tokenKey)
    }

    func deleteToken() {
        userDefaults.removeObject(forKey: tokenKey)
    }
}
