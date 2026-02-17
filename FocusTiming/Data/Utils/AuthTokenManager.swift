//
//  AuthTokenManager.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation
import Security

final class AuthTokenManager {
    
    static let shared = AuthTokenManager()
    
    private init() {}
    
    private let service = "com.focustime.auth"
    private let account = "googleAccessToken"
    
    // MARK: - Save
    
    func save(token: String) {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // remove old
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    
    // MARK: - Retrieve
    
    func retrieveToken() -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8)
        else { return nil }
        
        return token
    }
    
    
    // MARK: - Delete
    
    func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

