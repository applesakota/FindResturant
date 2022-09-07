//
//  Storage.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 5/27/22.
//

import Foundation

/// Data Storage Type. Contains all storage logic and abstract functionality
enum Storage {
    
    //MARK: - Storage Types
    
    /// UserDefaults, best for smaller data chunks
    case userDefaults(UserDefaults)
    
    /// Keychain, safe, encripted and best for storing sensitive data. Slower than User Defaults
    // case keycahin
    
    
    //MARK: - Public API
    
    /// Abstract set function that should be used to store data in Storage.
    /// - Parameters:
    ///    - value: Specific value of generic `AnyHashable`type.
    ///    - key: String identifier
    /// - Returns: Returns `true` if data was saved properly.
    func set(_ value: AnyHashable, key: String) -> Bool {
        switch self {
        case .userDefaults(let userDefaults):
            if value is NSNull {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(value, forKey: key)
            }
            return true
        }
    }
    
    /// Abstract get function will return value
    /// - Parameter key: `String` identifier.
    /// - Returns: Returns stored valus as `AnyHashable`, that need to be casted to specific type.
    func get(_ key: String) -> AnyHashable? {
        switch self {
        case .userDefaults(let userDefaults):
            return userDefaults.value(forKey: key) as? AnyHashable
        }
    }
    
    func delete(matching keyword: String) -> Bool {
        switch self {
        case .userDefaults(let userDefaults):
            return userDefaults.delete(matching: keyword)
        }
    }
    
    

    
}
