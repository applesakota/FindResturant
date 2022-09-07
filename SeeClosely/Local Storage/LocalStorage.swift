//
//  LocalStorage.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/2/22.
//

import Foundation


/// Local storage is class that should be uset to store all kind of persistent data
final class LocalStorage {
    
    //MARK: - Global shared instances
    
    static let standard = LocalStorage(storage: .userDefaults(UserDefaults.standard))
    
    //MARK: - Globals
    
    /// Local storage reference
    let storage: Storage
    
    //MARK: - Constructor
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    //MARK: - Public API
    
    //Save functions
    
    @discardableResult
    func save(string value: String, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(int value: Int, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(double value: Double, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(bool value: Bool, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(array value: NSArray, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(dictionary value: NSDictionary, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(dictionaries value: [NSDictionary], key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(data value: Data, key: String, forced: Bool = true) -> Bool {
        return self.save(value: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save<T: Codable>(codable value: T, key: String, forced: Bool = true) -> Bool {
        if let encoded = T.encodeObject(value) {
            return save(value: encoded, key: key, forced: forced)
        }
        return false
    }
    
    
    private func save(value: AnyHashable, key: String, forced: Bool) -> Bool {
        if let oldValue = storage.get(key) {
            if forced && storage.set(value, key: key) {
                if let oldDictionary = oldValue as? NSDictionary, let newDictionary = value as? NSDictionary {
                    print("📦 [LocalStorage]: Successfuly replaced \n\(oldDictionary))\n with \n\(newDictionary) for key: \(key).")
                    
                } else if let oldDictionaries = oldValue as? [NSDictionary], let newDictionaries = value as? [NSDictionary] {
                    print("📦 [LocalStorage]: Successfuly replaced \n\(oldDictionaries)\n with \n\(newDictionaries) for key: \(key).")
                    
                } else if let oldArray = oldValue as? NSArray, let newArray = value as? NSArray {
                    print("📦 [LocalStorage]: Successfuly replaced \n\(oldArray)\nwith \n\(newArray) for key: \(key).")
                    
                } else {
                    print("📦 [LocalStorage]: Successfuly replaced \"\(oldValue)\" with \"\(value)\" for key: \(key)")
                }
                
                return true
                
            } else {
                if let oldDictionary = oldValue as? NSDictionary, let newDictionary = value as? NSDictionary {
                    print("📦 [LocalStorage]: Failed to replace \n\(oldDictionary))\n with \n\(newDictionary) for key: \(key).")
                    
                } else if let oldDictionaries = oldValue as? [NSDictionary], let newDictionaries = value as? [NSDictionary] {
                    print("📦 [LocalStorage]: Failed to replace \n\(oldDictionaries)\n with \n\(newDictionaries) for key: \(key).")
                    
                } else if let oldArray = oldValue as? NSArray, let newArray = value as? NSArray {
                    print("📦 [LocalStorage]: Failed to replace \n\(oldArray)\nwith \n\(newArray) for key: \(key).")
                    
                } else {
                    print("📦 [LocalStorage]: Failed to replace \"\(oldValue)\" with \"\(value)\" for key: \(key)")
                }
                
                return false
            }
        }
        
        if storage.set(value, key: key) {
            
            if let dictionary = value as? NSDictionary {
                print("📦 [LocalStorage]: Successfuly stored \n\(dictionary))\n for key: \(key).")
            } else if let dictionaries = value as? [NSDictionary] {
                print("📦 [LocalStorage]: Successfuly stored \n\(dictionaries))\nfor key: \(key).")
            } else if let array = value as? NSArray {
                print("📦 [LocalStorage]: Successfuly stored \n\(array))\n for key: \(key).")
            } else {
                print("📦 [LocalStorage]: Successfuly stored \n\(value))\n for key: \(key).")
            }

            return true
            
        } else {
            
            if let dictionary = value as? NSDictionary {
                print("📦 [LocalStorage]: Failed to store \n\(dictionary))\n for key: \(key).")
            } else if let dictionaries = value as? [NSDictionary] {
                print("📦 [LocalStorage]: Failed to store \n\(dictionaries))\n for key: \(key).")
            } else if let array = value as? NSArray {
                print("📦 [LocalStorage]: Failed to store \n\(array))\n for key: \(key).")
            } else {
                print("📦 [LocalStorage]: Failed to store  \n\(value))\n for key: \(key).")
            }
            return false
        }
    }
    
    
    
    // Load functions
    
    func loadString(key: String) -> String? {
        return self.load(key: key) as? String
    }
    
    func loadInt(key: String) -> Int? {
        return self.load(key: key) as? Int
    }
    
    func loadDouble(key: String) -> Double? {
        return self.load(key: key) as? Double
    }
    
    func loadBool(key: String) -> Bool? {
        return self.load(key: key) as? Bool
    }
    
    func loadArray(key: String) -> NSArray? {
        return self.load(key: key) as? NSArray
    }
    
    func loadDictionary(key: String) -> NSDictionary? {
        return self.load(key: key) as? NSDictionary
    }
    
    func loadDictionaries(key: String) -> [NSDictionary]? {
        return self.load(key: key) as? [NSDictionary]
    }
    
    func loadData(key: String) -> Data? {
        return self.load(key: key) as? Data
    }
    
    func loadCodable<T: Codable>(key: String) -> T? {
        if let data = self.load(key: key) as? Data {
            let t: T? = T.decodeData(data)
            return t
        }
        return nil
    }
    
    private func load(key: String) -> AnyHashable? {
        if let value = storage.get(key) {
            if let dictionary = value as? NSDictionary {
                print("📦 [LocalStorage]: Successfuly retrived \n\(dictionary))\n for key: \(key).")
            } else if let dictionaries = value as? [NSDictionary] {
                print("📦 [LocalStorage]: Successfuly retrived \n\(dictionaries))\n for key: \(key).")
            } else if let array = value as? NSArray {
                print("📦 [LocalStorage]: Successfuly retrived \n\(array))\n for key: \(key).")
            } else {
                print("📦 [LocalStorage]: Successfuly retrived \n\(value))\n for key: \(key).")
            }
            return value
        }
        
        print("📦 [LocalStorage]: Failed to retrive value for key: \(key).")
        return nil
    }

}
