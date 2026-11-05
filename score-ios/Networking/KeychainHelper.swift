//
//  KeychainHelper.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import Foundation
import Security

enum KeychainHelper {

    // MARK: - Keys

    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"

    // MARK: - Functions

    static func save(_ value: String, for key: String) {
        delete(key)
        var item = baseQuery(for: key)
        item[kSecValueData as String] = Data(value.utf8)
        SecItemAdd(item as CFDictionary, nil)
    }

    static func read(_ key: String) -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func delete(_ key: String) {
        SecItemDelete(baseQuery(for: key) as CFDictionary)
    }

    // MARK: - Helpers

    private static func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
    }
}
