//
//  RESTService.swift
//  SeeClosely
//
//  Created by Petar Sakotic on 5/27/22.
//

import Foundation

/// List of all end points wrapped in single peace.
protocol RESTService {
    
    typealias DataCallBack = (RESTManager.ResponseResult<RESTManager.AnyResult>) -> Swift.Void
    
    ///Execute All Tags end point
    /// - Parameters:
    /// - location: Location string.
    /// - callback: callback function will be async after end point is call.
    func executeGetAllTags(location: String, _ callback: @escaping (RESTManager.ResponseResult<TagResults>)->Swift.Void)
    
    
    /// Execute All resturants end point
    ///  - Parameters:
    ///  - location: Location striing.
    ///  - callback: callback function will be asymc after end point is call
    func executeAllResturants(location: String, _ callback: @escaping (RESTManager.ResponseResult<ResturantResults>) -> Swift.Void)
    
    /// Execute all resturants for specific tag
    /// - Parameters:
    /// - location: Location String.
    /// - tag: Specific tag for query all resturants
    /// - callback: callback funtion will be async after end point is call
    func executeAllResturantsByTag(location: String, for tag: String, _ callback: @escaping (RESTManager.ResponseResult<ResturantResults>) ->Swift.Void)
    
}
