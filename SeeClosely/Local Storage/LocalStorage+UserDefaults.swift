//
//  LocalStorage+UserDefaults.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/2/22.
//

import Foundation

extension UserDefaults {

    /// - Parameters:
    ///  - keyword: if given key contains part of the keyword text it will be removed, if provided keyword is `empty` all items will be removed
    func delete(matching keyword: String) -> Bool {
        var flag = false
        if let keys = (self.dictionaryRepresentation() as NSDictionary).allKeys as? [String] {
            for key in keys {
                if keyword.isEmpty || key.contains(keyword) {
                    self.removeObject(forKey: key)
                    flag = true
                }
            }
        }
        return flag
    }
}
