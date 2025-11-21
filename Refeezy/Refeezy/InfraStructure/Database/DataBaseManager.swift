//
//  DataBaseManager.swift
//  New-MVVM-Demo
//
//  Created by Ahmed Abo Al-Regal on 23/02/2025.
//

import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {} // Prevent external initialization
    
    // Save a value to UserDefaults
    func save<T: Codable>(_ value: T, forKey key: String) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            userDefaults.set(encoded, forKey: key)
            userDefaults.synchronize() // Force save (not needed in modern iOS, but useful for debugging)
            print("✅ Successfully saved data for key: \(key)")
            return true
        } else {
            print("❌ Failed to encode data for key: \(key)")
            return false
        }
    }
    
    func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            print("❌ No data found in UserDefaults for key: \(key)")
            return nil
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: data) {
            print("✅ Successfully retrieved data for key: \(key): \(decoded)")
            return decoded
        } else {
            print("❌ Failed to decode data for key: \(key)")
            return nil
        }
    }
    
    // Remove a value from UserDefaults
    func remove(forKey key: String) -> Bool {
        if userDefaults.object(forKey: key) != nil {
            userDefaults.removeObject(forKey: key)
            return true // Successfully removed
        }
        return false // Key did not exist
    }
    
    // Clear all stored values in UserDefaults
    func clearAll() {
        userDefaults.dictionaryRepresentation().keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
