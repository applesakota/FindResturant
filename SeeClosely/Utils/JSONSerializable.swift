//
//  JSONSerializable.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 6/10/22.
//

import Foundation


protocol JSONSerializable {
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or some other.
    init?(_ dictionary: NSDictionary?)
    
    /// Function will convert instance into NSDIctionary
    ///  - Returns: NSDictionary with all key values set to JSON Corresponding fields
    func serialize() -> NSDictionary?
    
}
