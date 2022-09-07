//
//  AppGlobals.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/16/22.
//

import Foundation

/// Namespace containing all globar references used in the app
enum AppGlobals {
    
    /// UserDefaults standard local storage reference used in application.
    static var standardLocalStorage = LocalStorage.standard
    
    /// RestManager reference used in application.
    static var restManager = RESTManager.shared

}
