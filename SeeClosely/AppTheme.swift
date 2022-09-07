//
//  AppTheme.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/27/22.
//

import Foundation
import UIKit

/// AppThme contains all UI components.
enum AppTheme {
    
    static func regularFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    
}
